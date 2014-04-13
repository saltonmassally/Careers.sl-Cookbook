## Cookbook Name:: drupal-solr
## Recipe:: install_solr
##


# Extract war file from solr archive
ark 'solr_war' do
  url node['drupal-solr']['url']
  action :put
  owner node['drupal-solr']['tomcat_user']
end

remote_directory node['drupal-solr']['tomcat_lib_dir']  do
  files_mode "755"
  files_group node['drupal-solr']['tomcat_group']	
  files_owner node['drupal-solr']['tomcat_user']
  mode "755"
  owner node['drupal-solr']['tomcat_user']
  source "/usr/local/solr-#{node['drupal-solr']['solr_version']}/dist/solrj-lib"
  group node['drupal-solr']['tomcat_group']
end

remote_file "#{node['drupal-solr']['tomcat_conf_dir']}/log4j.properties" do 
  source "/usr/local/solr-#{node['drupal-solr']['solr_version']}/example/resources/log4j.properties"
  owner node['drupal-solr']['tomcat_user']
  group node['drupal-solr']['tomcat_group']
  mode 0755
end

remote_file "#{node['drupal-solr']['tomcat_webapp_dir']}/solr.war" do 
  source "/usr/local/solr-#{node['drupal-solr']['solr_version']}/dist/solr-#{node['drupal-solr']['solr_version']}.war "
  owner node['drupal-solr']['tomcat_user']
  group node['drupal-solr']['tomcat_group']
  mode 0755
end

directory "#{node['drupal-solr']['tomcat_home']}/solr" do
  owner node['drupal-solr']['tomcat_user']
  group node['drupal-solr']['tomcat_group']
  mode 0755
  recursive true
end


template "solr.xml" do
  path ::File.join(node["solr_app"]["solr_home"],"solr.xml")
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  source "solr.xml.erb"
  cookbook "solr_app"
  variables(
    :collections => Array(Pathname.new(node["solr_app"]["solr_home"]).children.select { |c| c.directory? }.collect { |p| p.basename })
  )
 notifies :restart, "service[tomcat]"
end

remote_file "download-solr" do
  source node['drupal-solr']['url']
  path src_filepath
  action :create_if_missing
end

bash 'install-solr-war' do
  cwd node['drupal-solr']['war_dir']
  code <<-EOH
    tar xzf #{src_filepath}
    cp apache-solr-#{node['drupal-solr']['solr_version']}/example/webapps/solr.war .
  EOH
  creates node['drupal-solr']['war_dir'] + "/solr.war"
  notifies :restart, "service[tomcat]"
end

execute "install-solr-home" do
  cwd node['drupal-solr']['war_dir']
  command <<-EOH
    ls #{node['drupal-solr']['home_dir']}
    cp -Rf apache-solr-#{node['drupal-solr']['solr_version']}/example/solr/. #{node['drupal-solr']['home_dir']}/
  EOH
  creates node['drupal-solr']['home_dir'] + "/conf"
  notifies :run, "execute[fix-perms-solr-home]", :immediately
  notifies :restart, "service[tomcat]"
end

execute "fix-perms-solr-home" do
  cwd node['drupal-solr']['home_dir']
  command <<-EOT
    chown -R #{node['tomcat']['user']} .
    chmod -R u+rwx .
  EOT
  action :nothing
end

template 'solr-context-file' do
  path "#{node['tomcat']['context_dir']}/#{node['drupal-solr']['app_name']}.xml"
  owner node['tomcat']['user']
  group node['tomcat']['group']
  mode 0644
  variables({
    :custom_file => node['drupal-solr']['custom_conf_file']
  })
  source "solr_context.xml.erb"
  notifies :restart, "service[tomcat]"
end
