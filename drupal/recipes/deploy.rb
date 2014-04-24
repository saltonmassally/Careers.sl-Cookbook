include_recipe "cron"
include_recipe 'deploy'


node[:deploy].each do |application, deploy|

  bash "change_owner" do
     code <<-EOH
        user = "root"
        chown -R #{deploy[:user]}:#{deploy[:group]} #{node[:drupal][:ebs][:mount_point]}
     EOH
   end

   directory node[:drupal][:ebs][:mount_point] do
      mode '0755'
      owner deploy[:user]
      group deploy[:group]
      recursive true
   end

   directory "#{deploy[:absolute_document_root]}sites/default/files" do
      mode '0755'
      owner deploy[:user]
      group deploy[:group]
      recursive true
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
  end


  bash "update_db" do
    user deploy[:user]
    cwd "#{deploy[:absolute_document_root]}"
    code <<-EOH
    drush updatedb
    EOH
  end
end




