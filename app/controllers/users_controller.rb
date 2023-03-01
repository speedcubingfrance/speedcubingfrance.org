class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_unless_admin!, except: [:edit, :update, :import, :import_from_wca]
  before_action :redirect_unless_authorized_delegate!, only: [:import, :import_from_wca]
  before_action :set_and_redirect_if_cannot_edit_user, only: [:edit, :update]

  def edit
  end

  def import
    @matches = []
  end

  def import_from_wca
    request_params = params.require(:import_user).permit(:query, :id)
    @matches = []
    success = false
    request_id = request_params[:id].to_i
    if request_id > 0
      # FIXME DRY this with a request taking a "if success" block
      success = RestClient.get(wca_api_user_url(request_id)) do |response, request, result, &block|
        case response.code
        when 200
          result_json = JSON.parse(response.body)
          user_json = result_json["user"]
          if user_json
            @matches << user_json
            User.create_or_update(user_json)
          end
          true
        else
          false
        end
      end
    else
      success = RestClient.get(wca_api_users_search_url(request_params[:query])) do |response, request, result, &block|
        case response.code
        when 200
          results_json = JSON.parse(response.body)
          @matches = results_json["result"]
          true
        else
          false
        end
      end
    end
    if success
      case @matches.size
      when 0
        flash[:warning] = I18n.t("users.no_results")
      when 1
        User.create_or_update(@matches.first)
        flash[:success] = I18n.t("users.successful_import", user: @matches.first["name"])
        return redirect_to users_path
      end
    else
      flash[:danger] = I18n.t("users.request_error")
    end
    render :import
  end

  def update
    if @user.update(user_params)
      flash[:success] = I18n.t("users.successful_update")
      redirect_to edit_user_path(@user)
    else
      render :edit
    end
  end

  def user_to_edit
    User.find(params[:id] || current_user.id)
  end

  def index
    @users = User.all.includes(:subscriptions).order(:name)
  end

  def set_user!
    @user = user_to_edit
    @user.editing_user = current_user
  end

  def set_and_redirect_if_cannot_edit_user
    set_user!
    unless current_user&.can_edit_user?(@user)
      flash[:danger] = I18n.t("users.cannot_edit")
      redirect_to root_url
    end
  end

  def user_params
    permitted_params = [:notify_subscription, :discussion_subscription, :newsletter_subscription, :city]
    if current_user.admin?
      permitted_params += [
        :admin,
        :communication,
        :french_delegate,
      ]
    end
    params.require(:user).permit(*permitted_params)
  end

  private :user_to_edit, :set_and_redirect_if_cannot_edit_user, :set_user!, :user_params
end
