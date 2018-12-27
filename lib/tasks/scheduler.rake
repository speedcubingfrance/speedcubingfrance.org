require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

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
        Competition.create_or_update(c)
        if Date.parse(c["announced_at"]) == Date.yesterday
          users_to_notify = User.subscription_notification_enabled.select(&:last_subscription).select do |u|
            u.last_subscription.until >= Date.today
          end
          users_to_notify.each do |u|
            NotificationMailer.with(user: u, competition: c).notify_of_new_competition.deliver_now
          end
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
end
