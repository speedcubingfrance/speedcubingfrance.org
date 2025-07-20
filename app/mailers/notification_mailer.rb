class NotificationMailer < ApplicationMailer
  def notify_of_expiring_subscription
    @user = params[:user]
    mail(to: @user.email, subject: "Votre adhésion à l'AFS arrive à expiration")
  end

  def notify_of_new_competition
    @competition = params[:competition]
    @wcacomp = params[:wcacomp]
    mail(to: "adherents-notifications@speedcubingfrance.org", subject: "La compétition #{@competition.name} vient d'être annoncée", reply_to: "contact@speedcubingfrance.org")
  end

  def notify_team_of_failed_job
    @task_name = params[:task_name]
    @error = params[:error]
    mail(to: "admin@speedcubingfrance.org", subject: "[cron.afs][error] Une tâche a échouée")
  end

  def notify_team_of_job_done
    @task_name = params[:task_name]
    @message = params[:message]
    mail(to: "admin@speedcubingfrance.org", subject: "[cron.afs][info] #{@task_name}")
  end

  def send_backup_to_team
    @message = params[:message]
    attachments["prod.dump"] = File.read('/tmp/prod.dump')
    mail(to: "admin@speedcubingfrance.org", subject: "[cron.afs][info] db backup")
  end
end
