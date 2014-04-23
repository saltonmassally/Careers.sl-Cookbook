include_recipe "cron"
include_recipe 'deploy'


node[:deploy].each do |application, deploy|

  bash "change_owner" do
     code <<-EOH
        user = "root"
        chown -R #{deploy[:user]}:#{deploy[:group]} #{node[:drupal][:ebs][:mount_point]}
     EOH
   end

   link node[:drupal][:ebs][:mount_point] do
     owner deploy[:user]
     group deploy[:group]
     to "#{deploy[:absolute_document_root]}sites/default/files"
     not_if "test -e  #{node[:drupal][:ebs][:mount_point]}"
   end	


  template "#{deploy[:absolute_document_root]}sites/default/settings.php" do
    source "settings.php.erb"
    owner deploy[:user]
    group deploy[:group]
    mode "0644"
    action :create
  end
 
  cron "drupal_cron" do
    command "cd #{deploy[:absolute_document_root]}; /usr/bin/php cron.php"
    minute "*/15"
    only_if  { File.exist?("#{deploy[:deploy_to]}/cron.php") }
  end


  bash "update_db" do
    user deploy[:user]
    cwd "#{deploy[:absolute_document_root]}"
    code <<-EOH
    drush updatedb
    EOH
  end
end




