override['postfix']['mail_type'] ='master'
override['postfix']['main']['smtpd_use_tls'] = 'no'
override['postfix']['main']['smtp_tls_CAfile'] = '/etc/ssl/certs/ca-certificates.crt'
override['postfix']['main']['mydestination'] = ''
override['postfix']['main']['smtp_sasl_auth_enable'] = 'yes'
override['postfix']['main']['relayhost'] = 'email-smtp.us-east-1.amazonaws.com:25'
override['postfix']['main']['mynetworks'] = '127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128'
override['postfix']['sasl']['smtp_sasl_user_name'] = 'user'
override['postfix']['sasl']['smtp_sasl_passwd'] = 'secret'
default['postfix']['main']['smtp_tls_security_level'] = 'encrypt'
default['postfix']['main']['smtp_tls_note_starttls_offer'] = 'yes'

default['postfix']['sasl_password_file'] = "#{node['postfix']['conf_dir']}/sasl_passwd"
default['postfix']['main']['smtp_sasl_password_maps'] = "hash:#{node['postfix']['sasl_password_file']}"
default['postfix']['main']['smtp_sasl_security_options'] = 'noanonymous'
