class UserMailer < ApplicationMailer

  def confirm(user)
    @user = user
    mail(to: user.email, subject: 'Votre inscription' + Rails.application.config.site[:name])
  end

end
