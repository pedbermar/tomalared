ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => 'gmail.com',
  :user_name => 'petertamei',
  :password => 'ap0te0sic0',
  :authentication => 'plain',
  :enable_starttls_auto => true
}
