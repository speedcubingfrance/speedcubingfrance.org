module ApplicationHelper
  def bootstrap_class_for(flash_type)
    {
      success: "alert-success",
      danger: "alert-danger",
      warning: "alert-warning",
      info: "alert-info",

      # For devise
      notice: "alert-success",
      alert: "alert-danger",

      recaptcha_error: "alert-danger",
    }[flash_type.to_sym] || flash_type.to_s
  end

  def wca_base_url
    ENV['WCA_BASE_URL'] || "https://www.worldcubeassociation.org"
  end

  def wca_token_url
    "#{wca_base_url}/oauth/token"
  end

  def wca_api_url(resource)
    "#{wca_base_url}/api/v0#{resource}"
  end

  def wca_api_competitions_url
    wca_api_url("/competitions")
  end

  def wca_registration_url(registration_id)
    "#{wca_base_url}/registrations/#{registration_id}/edit"
  end

  def wca_profile_url(wca_id)
    "#{wca_base_url}/persons/#{wca_id}"
  end

  def wca_competition_url(comp_id)
    "#{wca_base_url}/competitions/#{comp_id}"
  end

  def wca_persons_search_url
    "#{wca_base_url}/persons/?page=1&region=all&only_with_wca_ids=true&search="
  end

  def wca_api_user_url(wca_id)
    wca_api_url("/users/#{wca_id}")
  end

  def wca_api_users_search_url(query)
    wca_api_url("/search/users/?q=#{query}")
  end

  def wca_api_competitions_url(competition_id="")
    wca_api_url("/competitions/#{competition_id}")
  end

  def wca_api_competition_wcif_url(competition_id)
    "#{wca_api_competitions_url(competition_id)}/wcif"
  end

  def wca_client_id
    ENV['WCA_CLIENT_ID']
  end

  def wca_login_url(scopes)
    "#{wca_base_url}/oauth/authorize?response_type=code&client_id=#{wca_client_id}&scope=#{CGI.escape(scopes)}&redirect_uri=#{wca_callback_url}"
  end

  def wca_client_secret
    ENV['WCA_CLIENT_SECRET']
  end

  def page_title(page_title = "")
    base_title = "Association Française de Speedcubing"
    if page_title.blank?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  # https://github.com/thewca/worldcubeassociation.org/blob/c05b272fc0c8cef14d465df12c7b6c6a0da3779f/WcaOnRails/app/helpers/application_helper.rb#L202
  def flag_icon(iso2, html_options = {})
    html_options[:class] ||= ""
    html_options[:class] += " flag-icon flag-icon-#{iso2&.downcase}"
    content_tag :span, "", html_options
  end

  def fa_icon(id)
    content_tag :i, "", class: "fa fa-#{id}"
  end

  def link_to_wca_profile(wca_id, tooltip=true, text=nil)
    data = if tooltip
             {
               toggle: "tooltip",
               placement: "top",
             }
           else
             nil
           end
    unless wca_id.blank?
      link_to(text || wca_id,
              wca_profile_url(wca_id),
              target: "_blank",
              title: "Aller au profil WCA",
              data: data,
             )
    else
      text
    end
  end

  def has_manage_competitions_scope
    session[:scopes]&.include?("manage_competitions")
  end

  def add_to_packs(*names)
    @all_packs = capture do
      [@all_packs, *names].compact.join(",")
    end
  end
end
