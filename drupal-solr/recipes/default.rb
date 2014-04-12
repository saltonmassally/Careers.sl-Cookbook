## Cookbook Name:: drupal-solr
## Recipe:: default
##

include_recipe "drupal-solr::install_solr"
include_recipe "drush"

DRUSH = "drush --root='#{node['drupal-solr']['drupal_root']}'"

bash "download-apachesolr-module" do
  code "#{DRUSH} pm-download apachesolr-#{node['drupal-solr']['module_version']}"
  not_if "#{DRUSH} pm-list | grep apachesolr"
end

src_filepath = "#{Chef::Config['file_cache_path']}/SolrPhpClient.r22.2009-11-09.tgz"
solr_module_path_cmd = "#{DRUSH} php-eval \"print DRUPAL_ROOT . '/' . drupal_get_path('module', 'apachesolr');\""

remote_file "download-solrPhpClient" do
  source "https://solr-php-client.googlecode.com/files/SolrPhpClient.r22.2009-11-09.tgz"
  path src_filepath
  action :create_if_missing
  not_if { node['drupal-solr']['module_version'].match /^6.x-3|^7|8/ }
end

bash 'install-solrPhpClient' do
  code <<-EOH
    #{DRUSH} cc module-list
    cd $(#{solr_module_path_cmd})
    tar xzf #{src_filepath}
  EOH
  not_if "test -d $(#{solr_module_path_cmd})/SolrPhpClient"
  not_if { node['drupal-solr']['module_version'].match /^6.x-3|^7|8/ }
end

bash "enable-apachesolr-module" do
  code "#{DRUSH} pm-enable -y apachesolr_search"
  not_if "#{DRUSH} pm-list | grep apachesolr_search | grep Enabled"
end

bash "install-drupalized-solr-conf" do
  code <<-EOT
    cd $(#{solr_module_path_cmd})
    echo $PWD
    cp #{node['drupal-solr']['conf_source_glob']} #{node['drupal-solr']['home_dir']}/conf/
  EOT
  action :nothing
  subscribes :run, "execute[install-solr-home]", :delayed # being explicit since it'll fail if immediately
  notifies :run, "execute[fix-perms-solr-home]", :immediately
  notifies :restart, "service[tomcat]", :immediately # immediately - otherwise tomcat will restart too soon; chef bug?
end

execute "set-d7-solr-url" do
  command "#{DRUSH} solr-set-env-url http://localhost:#{node['tomcat']['port']}/#{node['drupal-solr']['app_name']}"
  only_if { node['drupal-solr']['module_version'].match /^6.x-3|^7|8/ }
end

execute "set-d6-solr-url" do
  command <<-EOH
    #{DRUSH} variable-set apachesolr_port #{node['tomcat']['port']}
    #{DRUSH} variable-set apachesolr_path /#{node['drupal-solr']['app_name']}
  EOH
  not_if {node['drupal-solr']['module_version'].match /^6.x-3|^7|8/ }
end

execute "set-solr-as-default-search" do
  command "#{DRUSH} vset search_default_module apachesolr_search"
  only_if { node['drupal-solr']['make_solr_default_search'] }
end

# If index_drupal_content attribute is false (default), Solr index
# has to be manually indexed after installation.
# If true, Drupal content will be indexed after every Chef run.
execute "index-site-content" do
  command "#{DRUSH} solr-reindex && echo 'Solr is indexing content ...' && #{DRUSH} solr-index 2>&1"
  only_if { node['drupal-solr']['index_drupal_content'] }
  action :nothing
  # nothing else in the cookbook can signal the proper timing for indexing data
  subscribes :run, "service[tomcat]"
end
