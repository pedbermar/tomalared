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

  def password_reset_instructions(user)
    mail(:to => user.email,
        :subject =>       "Password Reset Instructions",
        :from =>          "noreplay@tomalared.net",
        :content_type =>  "text/html",
        :sent_on =>       Time.now,
        #:body =>          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
    ) do |format|
        format.text
      end
  end

end

