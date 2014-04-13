include_recipe 'deploy'

node[:deploy].each do |application, deploy|

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  application "smssuite" do
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
     packages ["libpq-dev", "git-core", "mercurial"]
     restart_command "sleep #{deploy[:sleep_before_restart]} && #{node[:smssuite][:rapidsms_stack][:restart_command]}"

  django do
    requirements "requirements/base.txt"
    settings_template "settings.py.erb"
    debug False
    collectstatic "build_static --noinput"
    database do
      database node[:smssuite][:rapidsms_stack][:database][:name]
      engine node[:smssuite][:rapidsms_stack][:database][:engine]
      username node[:smssuite][:rapidsms_stack][:database][:username]
      password node[:smssuite][:rapidsms_stack][:database][:password]
    end
    database_master_role "packaginator_database_master"
  end

  gunicorn do
    only_if { node['roles'].include? 'packaginator_application_server' }
    app_module :django
    port 8080
  end

  celery do
    only_if { node['roles'].include? 'packaginator_application_server' }
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

a
