# frozen_string_literal: true
# Credit: https://github.com/thewca/worldcubeassociation.org/blob/1e8bfff9bd53aede092b298f0c282839de25256f/WcaOnRails/lib/gsuite_mailing_lists.rb

ENV['GOOGLE_APPLICATION_CREDENTIALS'] = Rails.root.join("credentials.json").to_s

require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'google/apis/admin_directory_v1'

module GsuiteMailingLists
  def self.sync_group(group, desired_emails)
    service = get_service

    messages = []
    desired_emails = desired_emails.map do |email|
      if email.include?("+")
        old_email = email
        email = email.gsub(/\+[^@]*/, '')
        messages << "Warning: '#{old_email}' contains a plus sign, and google groups seems to not support + signs in email addresses, so we're going to add '#{email}' instead."
      end
      email
    end

    members = service.fetch_all(items: :members) do |token|
      service.list_members(group, page_token: token)
    end
    current_emails = members.map(&:email)

    emails_to_remove = current_emails - desired_emails
    emails_to_add = desired_emails - current_emails

    # First, remove all the emails we don't want.
    emails_to_remove.each do |email|
      messages << "#{email} retiré de #{group}."
      service.delete_member(group, email)
    end

    # Last, add all the emails we do want.
    emails_to_add.each do |email|
      messages << "#{email} ajouté à #{group}."
      new_member = Google::Apis::AdminDirectoryV1::Member.new(email: email)
      service.insert_member(group, new_member)
    end
    messages
  end

  def self.get_service
    scopes = [
      'https://www.googleapis.com/auth/admin.directory.group',
    ]
    authorization = Google::Auth.get_application_default(scopes)

    Google::Apis::AdminDirectoryV1::DirectoryService.new.tap do |service|
      service.authorization = authorization
    end
  end
end
