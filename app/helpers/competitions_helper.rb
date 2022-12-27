module CompetitionsHelper
  def class_and_status_from_person(sub_by_id, sub_by_name, person)
    if @subscribers_by_id.include?(person["wcaId"]) ||
       @subscribers_by_name.include?(I18n.transliterate(person["name"].downcase))
      ["success", I18n.t("competitions.registrations.subscribed")]
    elsif person["wcaId"]
      ["danger", I18n.t("competitions.registrations.must_pay")]
    else
      ["warning", link_to(I18n.t("competitions.registrations.check_if_new"), "#", class: "link-check", data: { id: person["registration"]["wcaRegistrationId"] })]
    end
  end
end
