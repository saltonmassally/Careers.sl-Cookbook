## Cookbook Name:: drupal-solr
## Recipe:: install_solr
##

include_recipe "curl"

directory node['drupal-solr']['home_dir'] do
  owner node['drupal-solr']['tomcat_user']
  group node['drupal-solr']['tomcat_group']
  mode 0775
  recursive true
end

directory node['drupal-solr']['war_dir'] do
  owner node['drupal-solr']['tomcat_user']
  group node['drupal-solr']['tomcat_group']
  mode 0775
  recursive true
end


# Extract war file from solr archive
ark 'solr_war' do
  url node['drupal-solr']['url']
  action :cherry_pick
  creates node["drupal-solr"]["archive_war_path"]
  path ::File.join(Chef::Config[:file_cache_path], "solr_app")
  strip_leading_dir false
end

src_filepath = "#{Chef::Config['file_cache_path']}/solr-#{node['drupal-solr']['solr_version']}.tgz"

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
