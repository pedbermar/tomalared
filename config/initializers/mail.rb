ActionMailer::Base.smtp_settings = {
  :address => "smtp.riseup.net",
  :port => 587,
  :domain => 'tomalared.net',
  :user_name => 'tomalared',
  :password => 'T0malare]',
  :authentication => 'plain',
  :enable_starttls_auto => true
}

