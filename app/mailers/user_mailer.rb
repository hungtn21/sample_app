class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    @greeting = I18n.t("user_mailer.account_activation.greeting",
                       name: @user.name)
    mail to: @user.email,
         subject: I18n.t("user_mailer.account_activation.subject")
  end

  def password_reset user
    @user = user
    @greeting = I18n.t("user_mailer.password_reset.greeting", name: @user.name)
    mail to: @user.email, subject: I18n.t("user_mailer.password_reset.subject")
  end

  def password_reset_confirmation user
    @user = user
    @login_url = login_url
    @greeting = I18n.t("user_mailer.password_reset_confirmation.greeting",
                       name: @user.name)
    mail to: @user.email,
         subject: I18n.t("user_mailer.password_reset_confirmation.subject")
  end
end
