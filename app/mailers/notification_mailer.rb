class NotificationMailer < ApplicationMailer
  def notify_of_expiring_subscription
    @user = params[:user]
    mail(to: @user.email, subject: "Votre adhésion à l'AFS arrive à expiration")
  end

  def notify_of_new_competition
    @user = params[:user]
    @competition = params[:competition]
    mail(to: @user.email, subject: "La compétition #{@competition.name} vient d'être annoncée")
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
end
