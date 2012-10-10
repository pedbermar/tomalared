ActionMailer::Base.smtp_settings = {
  :address => "servidor de correo",
  :port => 587,
  :domain => 'dominio',
  :user_name => 'usuario',
  :password => 'contraseña',
  :authentication => 'plain',
  :enable_starttls_auto => true
}

