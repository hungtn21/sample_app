class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    @greeting = I18n.t("user_mailer.account_activation.greeting",
                       name: @user.name)

    mail to: user.email,
         subject: I18n.t("user_mailer.account_activation.subject")
  end
end
