class User < ApplicationRecord
  include WCAModel
  # List of fields we accept in the db
  @@obj_info = %w(id name email wca_id country_iso2 avatar_url avatar_thumb_url gender birthdate delegate_status)

  has_many :subscriptions, -> { order(:payed_at) }

  scope :subscription_notification_enabled, -> { where(notify_subscription: true).where.not(email: nil) }
  scope :subscription_discussion_enabled, -> { where(discussion_subscription: true).where.not(email: nil) }
  scope :subscription_newsletter_enabled, -> { where(newsletter_subscription: true).where.not(email: nil) }
  scope :french_delegates, -> { where(french_delegate: true).where.not(delegate_status: [nil, ""]) }

  # NOTE: /!\ Important: this is *not* the list of subscribers.
  # This is a list of person who *did* log in the website, and are subscribers.
  # To get the list of subscribers, go through Subscription.active scope
  scope :with_active_subscription, -> { joins(:subscriptions).where("subscriptions.payed_at > ?", 1.year.ago) }

  after_save :try_associate_subscriptions

  attr_accessor :editing_user

  validate :cannot_demote_themselves
  def cannot_demote_themselves
    if editing_user == self && admin_was == true && admin == false
      errors.add(:admin, "impossible de vous enlever le statut d'aministrateur, demandez à un autre administrateur de le faire.")
    end
  end

  def can_edit_user?(user)
    admin? || user.id == self.id
  end

  def can_manage_delegate_matters?
    admin? || french_delegate?
  end

  def can_manage_communication_matters?
    admin? || comm?
  end

  def can_manage_calendar?
    can_manage_delegate_matters? || can_manage_communication_matters?
  end

  def can_manage_online_comps?
    admin? || comm?
  end

  def last_subscription
    subscriptions.last
  end

  def admin?
    admin
  end

  def comm?
    communication
  end

  def delegate?
    !delegate_status.blank?
  end

  def french_delegate?
    delegate? && french_delegate
  end

  def country_name
    country&.name
  end

  def country
    Country.find_by_iso2(country_iso2)
  end

  def friendly_delegate_status
    case delegate_status
    when "candidate_delegate"
      "Candidat Délégué WCA"
    when "senior_delegate"
      "Délégué WCA Sénior"
    when "delegate"
      "Délégué WCA"
    else
      ""
    end
  end

  def friendly_birthdate
    birthdate&.strftime("%d-%m-%Y")
  end

  def self.process_json(json_user)
    # if such field exists, we are importing the WCIF,
    # else it's just a regular user login
    if json_user.include?("wcaUserId")
      json_user["id"] = json_user.delete("wcaUserId")
    end

    if json_user.include?("avatar")
      json_user["avatar_url"] = json_user["avatar"]["url"]
      json_user["avatar_thumb_url"] = json_user["avatar"]["thumbUrl"] || json_user["avatar"]["thumb_url"]
      json_user.delete("avatar")
    end
    %w(delegatesCompetition organizesCompetition registration personalBests).each do |k|
      json_user.delete(k)
    end
    if json_user.include?("birthdate")
      json_user["birthdate"] = json_user["birthdate"].to_date
    elsif json_user.include?("dob")
      json_user["birthdate"] = json_user["dob"].to_date
    end
    json_user
  end

  def self.create_or_update(json_user)
    json_user = process_json(json_user)
    wca_create_or_update(json_user)
  end

  def try_associate_subscriptions
    unless wca_id.blank?
      Subscription.userless.where(wca_id: wca_id).update(user_id: id)
    end
    Subscription.userless.where("concat(lower(firstname), ' ', lower(name)) = ?", name.downcase).update(user_id: id)
  end

  def serializable_hash(options = nil)
    {
      id: id,
      name: name,
      country_iso2: country_iso2&.downcase,
      wca_id: wca_id,
    }
  end

  private :try_associate_subscriptions
end
