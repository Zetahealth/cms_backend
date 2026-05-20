class CustomDeviseMailer < Devise::Mailer
  default from: 'zcorp774@gmail.com'
  default template_path: 'custom_devise_mailer'

  def reset_password_instructions(record, token, opts = {})
    @resource = record
    @token = token
    @reset_url = "https://afp.connectorcore.com/reset-password?reset_password_token=#{token}"

    mail(
      to: record.email,
      subject: "Reset Password"
    )
  end
end
