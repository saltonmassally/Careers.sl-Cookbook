## Cookbook Name:: drupal-solr
## Recipe:: install_solr
##

include_recipe 'apache2::service'
include_recipe 'apache2::service'
# Extract war file from solr archive
ark "solr-#{node['drupal-solr']['solr_version']}" do
  url node['drupal-solr']['url']
  action :put
  owner node['drupal-solr']['tomcat_user']
end

bash "copy_source_1" do
    code <<-EOH
    cp -r /usr/local/solr-#{node['drupal-solr']['solr_version']}/dist/solrj-lib/* #{node['drupal-solr']['tomcat_lib_dir']}
    chown -R #{node['drupal-solr']['tomcat_user']}:#{node['drupal-solr']['tomcat_group']} #{node['drupal-solr']['tomcat_lib_dir']}
    EOH
end


remote_file "#{node['drupal-solr']['tomcat_conf_dir']}/log4j.properties" do 
  source "file:///usr/local/solr-#{node['drupal-solr']['solr_version']}/example/resources/log4j.properties"
  owner node['drupal-solr']['tomcat_user']
  group node['drupal-solr']['tomcat_group']
  mode 0755
end

remote_file "#{node['drupal-solr']['tomcat_webapp_dir']}/solr.war" do 
  source "file:///usr/local/solr-#{node['drupal-solr']['solr_version']}/dist/solr-#{node['drupal-solr']['solr_version']}.war "
  owner node['drupal-solr']['tomcat_user']
  group node['drupal-solr']['tomcat_group']
  mode 0755
end

directory node['drupal-solr']['solr_home'] do
  owner node['drupal-solr']['tomcat_user']
  group node['drupal-solr']['tomcat_group']
  mode 0755
  recursive true
end

directory "#{node['drupal-solr']['solr_home']}/conf" do
  owner node['drupal-solr']['tomcat_user']
  group node['drupal-solr']['tomcat_group']
  mode 0755
  recursive true
end

bash "copy_source_2" do
    code <<-EOH
    cp -r /usr/local/solr-#{node['drupal-solr']['solr_version']}/example/solr/collection1/conf/* #{node['drupal-solr']['solr_home']}
    chown -R #{node['drupal-solr']['tomcat_user']}:#{node['drupal-solr']['tomcat_group']} #{node['drupal-solr']['tomcat_lib_dir']}
    EOH
end


template "#{node['drupal-solr']['tomcat_conf_dir']}/Catalina/localhost/solr_context.xml" do
  owner node['drupal-solr']['tomcat_user']
  group node['drupal-solr']['tomcat_group']
  source "solr_context.xml.erb"
end

directory "#{node['drupal-solr']['solr_home']}/drupal" do
  owner node['drupal-solr']['tomcat_user']
  group node['drupal-solr']['tomcat_group']
  mode 0755
  recursive true
end


[ 
   'elevate.xml',
   'mapping-ISOLatin1Accent.txt',
   'protwords.txt',
   'schema.xml',
   'schema_extra_fields.xml',
   'schema_extra_types.xml',
   'solrconfig.xml',
   'solrconfig_extra.xml',
   'solrcore.properties',
   'stopwords.txt',
   'synonyms.txt',
].each do |script|
  cookbook_file "#{node['drupal-solr']['solr_home']}/conf/#{script}" do
    source "#{script}"
    action :create_if_missing
    owner node['drupal-solr']['tomcat_user']
    group node['drupal-solr']['tomcat_group']
    mode 0755
  end
end

bash "change_permissiomn" do
    code <<-EOH
    chown -R #{node['drupal-solr']['tomcat_user']}:#{node['drupal-solr']['tomcat_group']} #{node['drupal-solr']['solr_home']}/conf
    EOH
end

bash "copy_source_3" do
    code <<-EOH
    cp -r #{node['drupal-solr']['solr_home']}/conf/* #{node['drupal-solr']['solr_home']}/drupal
    chown -R #{node['drupal-solr']['tomcat_user']}:#{node['drupal-solr']['tomcat_group']} #{node['drupal-solr']['solr_home']}/drupal
    EOH
end

template "#{node['drupal-solr']['solr_home']}/solr.xml" do
  owner node['drupal-solr']['tomcat_user']
  group node['drupal-solr']['tomcat_group']
  source 'drupal_context.xml.erb'
end




web_app deploy[:application] do
    docroot deploy[:absolute_document_root]
    server_name deploy[:domains].first
    unless deploy[:domains][1, deploy[:domains].size].empty?
      server_aliases deploy[:domains][1, deploy[:domains].size]
    end
    mounted_at deploy[:mounted_at]
    ssl_certificate_ca deploy[:ssl_certificate_ca]
    if application == 'root'
      target_context ''
    else
      target_context "#{application}/"
    end
  end

  template "#{node[:apache][:dir]}/ssl/#{deploy[:domains].first}.crt" do
    mode 0600
    source 'ssl.key.erb'
    variables :key => deploy[:ssl_certificate]
    notifies :restart, "service[apache2]"
    only_if do
      deploy[:ssl_support]
    end
  end

  template "#{node[:apache][:dir]}/ssl/#{deploy[:domains].first}.key" do
    mode 0600
    source 'ssl.key.erb'
    variables :key => deploy[:ssl_certificate_key]
    notifies :restart, "service[apache2]"
    only_if do
      deploy[:ssl_support]
    end
  end

  template "#{node[:apache][:dir]}/ssl/#{deploy[:domains].first}.ca" do
    mode 0600
    source 'ssl.key.erb'
    variables :key => deploy[:ssl_certificate_ca]
    notifies :restart, "service[apache2]"
    only_if do
      deploy[:ssl_support] && deploy[:ssl_certificate_ca]
    end
  end

  # move away default virtual host so that the new app becomes the default virtual host
  execute 'mv away default virtual host' do
    action :run
    command "mv #{node[:apache][:dir]}/sites-enabled/000-default \
#{node[:apache][:dir]}/sites-enabled/zzz-default"
    notifies :reload, "service[apache2]", :delayed
    only_if do
      ::File.exists?("#{node[:apache][:dir]}/sites-enabled/000-default")
    end
  end

end

include_recipe 'opsworks_java::context'


include_recipe "opsworks_java::#{node['opsworks_java']['java_app_server']}_service"

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'java'
    Chef::Log.debug("Skipping deploy::java application #{application} as it is not a Java app")
    next
  end

  # ROOT has a special meaning and has to be capitalized
  if application == 'root'
    webapp_name = 'ROOT'
  else
    webapp_name = application
  end

  template "context file for #{webapp_name}" do
    path ::File.join(node['opsworks_java'][node['opsworks_java']['java_app_server']]['context_dir'], "#{webapp_name}.xml")
    source 'webapp_context.xml.erb'
    owner node['opsworks_java'][node['opsworks_java']['java_app_server']]['user']
    group node['opsworks_java'][node['opsworks_java']['java_app_server']]['group']
    mode 0640
    backup false
    only_if { node['opsworks_java']['datasources'][application] }
    variables(:resource_name => node['opsworks_java']['datasources'][application], :application => application)
    notifies :restart, "service[#{node['opsworks_java']['java_app_server']}]"
  end
end

