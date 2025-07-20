require "#{Rails.root}/app/helpers/application_helper"
require "#{Rails.root}/lib/gsuite_mailing_lists"
include ApplicationHelper
include GsuiteMailingLists

namespace :scheduler do
  desc "Daily task to get WCA competitions"
  task :get_wca_competitions => :environment do
    puts "Getting competitions"
    url_params = {
      sort: "-start_date",
      country_iso2: "FR",
      start: "#{2.days.ago.to_date}",
    }
    begin
      comps_response = RestClient.get(wca_api_competitions_url, params: url_params)
      competitions = JSON.parse(comps_response.body)
      competitions.each do |c|
        puts "Importing #{c["name"]}"
        _, comp_obj = Competition.create_or_update(c)
        if comp_obj.announced_at.to_date == Time.now.to_date.yesterday
          NotificationMailer.with(competition: comp_obj, wcacomp: c).notify_of_new_competition.deliver_now
        end
      end
      puts "Done."
      if competitions.any?
        names = competitions.map { |c| c["name"] }
        message = "Succès de l'importation des compétitions suivantes : #{names.join(", ")}."
        NotificationMailer.with(task_name: "get_wca_competitions", message: message).notify_team_of_job_done.deliver_now
      end
    rescue => err
      puts "Could not get competitions from the WCA, error:"
      puts err
      puts "---"
      puts "Trying to notify the software team."
      NotificationMailer.with(task_name: "get_wca_competitions", error: err).notify_team_of_failed_job.deliver_now
    end
  end

  desc "Daily task to send subscriptions reminder"
  task :send_subscription_reminders => :environment do
    users_to_notify = User.subscription_notification_enabled.select(&:last_subscription).select do |u|
      u.last_subscription.until == 2.days.from_now.to_date
    end
    puts "#{users_to_notify.size} utilisateur à notifier."
    users_done = []
    users_to_notify.each do |u|
      puts u.name
      begin
        NotificationMailer.with(user: u).notify_of_expiring_subscription.deliver_now
        users_done << u
      rescue => err
        puts "Could not notify user!"
        NotificationMailer.with(task_name: "send_subscription_reminders", error: err).notify_team_of_failed_job.deliver_now
      end
    end
    message = "Nombre d'utilisateurs notifiés : #{users_done.size}/#{users_to_notify.size}"
    if users_done.any?
      message += " (#{users_done.map(&:name).join(", ")})"
    end
    message += "."
    NotificationMailer.with(task_name: "send_subscription_reminders", message: message).notify_team_of_job_done.deliver_now
  end

  desc "Daily task to sync mailing lists"
  task :sync_groups => :environment do
    begin
      sync_job_messages = []
      delegates_emails = User.french_delegates.map(&:email)
      # Delegates mailing list
      sync_job_messages << GsuiteMailingLists.sync_group("delegates@speedcubingfrance.org", delegates_emails)
      subscribers_with_notifications = User.subscription_notification_enabled.with_active_subscription.map(&:email)
      # We also need ot make sure these users are "managers" of the group to be
      # able to post.
      subscribers_with_notifications << "contact@speedcubingfrance.org"
      subscribers_with_notifications << "notifications@speedcubingfrance.org"
      # Subscribers notifications list (new competition announced)
      sync_job_messages << GsuiteMailingLists.sync_group("adherents-notifications@speedcubingfrance.org", subscribers_with_notifications.uniq)

      all_subscribers = Subscription.active.includes(:user).map { |s| s.user&.email || s.email }
      # Subscribers mailing list
      sync_job_messages << GsuiteMailingLists.sync_group("adherents@speedcubingfrance.org", all_subscribers.uniq)
      # Subscribers discussion list
      subscribers_with_discussion = User.subscription_discussion_enabled.with_active_subscription.map(&:email)
      subscribers_with_discussion << "contact@speedcubingfrance.org"
      sync_job_messages << GsuiteMailingLists.sync_group("adherents-discussions@speedcubingfrance.org", subscribers_with_discussion.uniq)
      # Subscribers newsletter
      subscribers_with_newsletter = User.subscription_newsletter_enabled.with_active_subscription.map(&:email)
      subscribers_with_newsletter << "contact@speedcubingfrance.org"
      sync_job_messages << GsuiteMailingLists.sync_group("newsletter@speedcubingfrance.org", subscribers_with_newsletter.uniq)

      message = "La synchronisation des groupes a été effectuée.\n"
      if sync_job_messages.empty?
        message += "Aucun changement n'a été nécessaire." if sync_job_messages.empty?
      else
        message += sync_job_messages.join("\n")
      end
      NotificationMailer.with(task_name: "sync_groups", message: message).notify_team_of_job_done.deliver_now
    rescue => err
      NotificationMailer.with(task_name: "sync_groups", error: err).notify_team_of_failed_job.deliver_now
    end
  end
end
