include_recipe "cron"
include_recipe 'deploy'


node[:deploy].each do |application, deploy|

  template "#{deploy[:deploy_to]}/current/sites/default/settings.php" do
    source "settings.php.erb"
    owner deploy[:user]
    group deploy[:group]
    action :create
  end
 
  cron "drupal_cron" do
    command "cd #{deploy[:deploy_to]}/current; /usr/bin/php cron.php"
    minute "*/15"
    only_if  { File.exist?("#{deploy[:deploy_to]}/cron.php") }
  end


  bash "update_db" do
    user deploy[:user]
    cwd deploy[:deploy_to]
    code <<-EOH
    drush updatedb
    EOH
  end
end




