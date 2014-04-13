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

copy drupal specifc files over to the config stuff

