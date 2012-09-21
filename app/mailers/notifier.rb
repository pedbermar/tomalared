class Notifier < ActionMailer::Base

  def activation_instructions(user)

    @account_activation_url = activate_account_url(user.perishable_token)

    mail(:to => user.email_address_with_name,
         :subject => "Instrucciones de activacion",
         :from => "tomalared.net <noreply@tomalared.net>",
         :fail_to => "tomalared.net <noreply@tomalared.net>"
    ) do |format|
      format.text
    end
  end

  def activation_confirmation(user)

    mail(:to => user.email_address_with_name,
         :subject => "Activacion Completada",
         :from => "tomalared.net <noreply@tomalared.net>",
         :fail_to => "tomalared.net <noreply@tomalared.net>"
    ) do |format|
      format.text
    end
  end
end

