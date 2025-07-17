class ApplicationMailer < ActionMailer::Base
  default from: Settings.defaults.email_from
  layout "mailer"
end
