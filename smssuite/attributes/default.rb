default[:smssuite][:sqs][:AWS_ACCESS_KEY_ID] = 'secret'
default[:smssuite][:sqs][:AWS_SECRET_ACCESS_KEY] = 'secret'
default[:smssuite][:dev_host] = ''
default[:smssuite][:secret_key] = 'secret'
default[:smssuite][:raven_dns] = ''
default[:smssuite][:backend][:kannel][:sendsms_url] = ''
default[:smssuite][:backend][:kannel][:sendsms_params][:smsc] = 'africell'
default[:smssuite][:backend][:kannel][:sendsms_params][:from] = 'SHORT_CODE'
default[:smssuite][:backend][:kannel][:sendsms_params][:username] = 'secret'
default[:smssuite][:backend][:kannel][:sendsms_params][:password] = 'secret'
default[:smssuite][:database][:name] = 'prod_db_smssuite_careerssl'
default[:smssuite][:database][:user] = 'secret'
default[:smssuite][:database][:password] = 'secret'
default[:smssuite][:database][:host] = ''
default[:smssuite][:database][:port] = 3306
default[:smssuite][:cache][:location] = '127.0.0.1:11211'
