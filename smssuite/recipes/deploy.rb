include_recipe 'deploy'

node[:deploy].each do |deploy_application, deploy|

  application "smssuite" do
     name 'smssuite'
     path deploy[:deploy_to]
     owner deploy[:user]
     group deploy[:group]
     repository deploy[:scm][:repository]
     revision deploy[:scm][:revision]
     migrate node[:smssuite][:rapidsms_stack][:migrate]
     migration_command node[:smssuite][:rapidsms_stack][:restart_command]
     environment deploy[:environment].to_hash
     symlink_before_migrate( node[:smssuite][:rapidsms_stack][:restart_command] )
     action deploy[:action]
     packages ["enchant"]
     restart_command "sleep #{deploy[:sleep_before_restart]} && #{node[:smssuite][:rapidsms_stack][:restart_command]}"

     django do
       requirements "requirements/base.txt"
       settings_template "settings.py.erb"
       debug True
       collectstatic "build_static --noinput"
       database do
         database node[:smssuite][:rapidsms_stack][:database][:name]
         engine node[:smssuite][:rapidsms_stack][:database][:engine]
         username node[:smssuite][:rapidsms_stack][:database][:username]
         password node[:smssuite][:rapidsms_stack][:database][:password]
       end
     end

     gunicorn do
       app_module :django
       port node[:smssuite][:rapidsms_stack][:gunicorn][:port]
     end

     celery do
       config "celery_settings.py"
       django true
       celerybeat true
       celerycam true
       broker do
         transport "redis"
       end
     end

     nginx_load_balancer do
       only_if { node['roles'].include? 'packaginator_load_balancer' }
       application_port 8080
       static_files "/site_media" => "site_media"
     end

   end

end

