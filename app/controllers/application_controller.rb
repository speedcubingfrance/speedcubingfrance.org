class ApplicationController < ActionController::Base
  include ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :force_no_cache, unless: Rails.env.production?

  helper_method :current_user

  rescue_from ActiveRecord::RecordNotFound, with: -> { raise ActionController::RoutingError.new('Not Found') }

  before_action :set_locale
  def set_locale
    # If the locale for the session is not set, we want to infer it from the following sources:
    #  - the current user preferred locale
    #  - the Accept-Language http header
    session[:locale] ||= current_user&.preferred_locale || http_accept_language.language_region_compatible_from(I18n.available_locales)
    I18n.locale = session[:locale] || I18n.default_locale
  end

  def update_locale
    # Validate the requested locale by looking at those available
    if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym)
      session[:locale] = params[:locale]

      # Display the success message in the new language!
      if current_user.nil? || current_user.update(preferred_locale: session[:locale])
        flash[:success] = I18n.t('users.update_locale.success', locale: session[:locale])
      else
        flash[:danger] = I18n.t('users.update_locale.failure')
      end
    else
      flash[:danger] = I18n.t('users.update_locale.unavailable')
    end
    redirect_to params[:current_url] || root_path
  end

  def force_no_cache
    response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def current_user
    begin
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue Exception => e
      nil
    end
  end

  def authenticate_user!
    if !current_user
      session[:return_to] ||= request.original_url
      redirect_to signin_url
    end
  end

  def redirect_unless_admin!
    unless current_user&.admin?
      redirect_to root_url, :alert => I18n.t("users.no_rights.admin")
    end
  end

  def redirect_unless_authorized_delegate!
    unless current_user&.can_manage_delegate_matters?
      redirect_to root_url, :alert => I18n.t("users.no_rights.delegate")
    end
  end

  def redirect_unless_comm!
    unless current_user&.can_manage_communication_matters?
      redirect_to root_url, :alert => I18n.t("users.no_rights.communication")
    end
  end

  def redirect_unless_can_manage_online_competitions!
    unless current_user&.can_manage_online_comps?
      redirect_to root_url, alert: I18n.t("users.no_rights.generic")
    end
  end

  private :current_user, :force_no_cache, :authenticate_user!,
    :redirect_unless_admin!, :redirect_unless_authorized_delegate!,
    :redirect_unless_can_manage_online_competitions!
end
