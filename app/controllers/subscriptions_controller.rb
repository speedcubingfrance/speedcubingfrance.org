require 'csv'

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_unless_admin!, except: [:index, :subscriptions_list]
  before_action :redirect_unless_comm!
  before_action :set_subscription, only: [:edit, :update]

  def update
    if @subscription.update(subscription_params)
      flash[:success] = I18n.t("subscriptions.successful_update")
      redirect_to subscriptions_list_path
    else
      render :edit
    end
  end

  def index
    @subscribers = Subscription.active.includes(:user).order(:firstname, :name).group_by do |s|
      "#{s.firstname.downcase} #{s.name.downcase}"
    end.values.map(&:first)
  end

  def edit
  end

  def subscriptions_list
    @subscriptions = Subscription.all.order(payed_at: :desc)
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy
    flash[:success] = I18n.t("subscriptions.deleted")
    redirect_to subscriptions_list_url
  end

  def import
    subscriptions = params.require(:subscriptions)
    subscriptions.each do |sub|
      sub_params = sub.permit(:name, :firstname, :wca_id, :email, :payed_at, :hello_asso_name)
      # We may add/change it later, so we cannot use it for the find
      wca_id = sub_params.delete(:wca_id)
      new_subscription = Subscription.find_or_initialize_by(sub_params)
      unless wca_id.blank?
        new_subscription.wca_id = wca_id
      end
      # We separate the find and the save so that any possible WCA ID is set when entering after_create callbacks
      new_subscription.save!
    end
    redirect_to subscriptions_list_url
  end

  def review_csv
    csvfile = params.require(:import_form).require(:csvfile)
    @new_subscriptions = []
    @subscriptions = []
    if csvfile.methods.include?(:path)
      csv = CSV.parse(File.read(csvfile.path, encoding: 'bom|utf-8'), headers: true, col_sep: ';')
      # Find out the correct header to use for the WCA ID.
      # To HelloAsso programmers: why would you put a line break in custom fields?
      wca_id_header = csv.headers.select { |h| h =~ /ID WCA/ }.first
      csv.each do |row|
        # Row may not follow a specific format, however we should have the following headers:
        # Nom;Prénom;Date;Email;Attestation;Champ additionnel: ID WCA (si connu)
        row_ha_name = "#{row["Prénom"].strip}-#{row["Nom"].strip}"
        subscription = Subscription.find_or_initialize_by(payed_at: DateTime.parse(row["Date"]),
                                                          hello_asso_name: row_ha_name)
        if subscription.new_record?
          subscription.assign_attributes(name: row["Nom"].strip,
                                         firstname: row["Prénom"].strip,
                                         email: row["Email acheteur"]&.strip,
                                         wca_id: row[wca_id_header])
          @new_subscriptions << subscription
        else
          @subscriptions << subscription
        end
      end
    end
    render :review_import
  end

  private
  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def subscription_params
    params.require(:subscription).permit(:name, :firstname, :email, :wca_id)
  end
end
