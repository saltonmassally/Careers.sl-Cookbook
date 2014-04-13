## Cookbook Name:: drupal-solr
## Attribute:: default

# must be one of the versions available at http://archive.apache.org/dist/lucene/solr/
# must be consistent with node['drupal-solr']['apachesolr_conf_dir']


default['drupal-solr']['solr_version']   = '4.7.1'
default['drupal-solr']['url']       = "http://archive.apache.org/dist/lucene/solr/" +
                                       node['drupal-solr']['solr_version'] + "/solr-" +
                                       node['drupal-solr']['solr_version']+ ".tgz"
default['drupal-solr']['app_name']  = "solr"
default['drupal-solr']['log_format'] = "common"
default['drupal-solr']['custom_conf_file'] = ''
default['drupal-solr']['tomcat_user'] = node['opsworks_java']['tomcat']['user']
default['drupal-solr']['tomcat_group'] = node['opsworks_java']['tomcat']['group']
default['drupal-solr']['tomcat_lib_dir'] = node['opsworks_java']['tomcat']['lib_dir']
default['drupal-solr']['tomcat_conf_dir'] = node['opsworks_java']['tomcat']['catalina_base_dir']
default['drupal-solr']['tomcat_webapp_dir'] = node['opsworks_java']['tomcat']['webapps_base_dir']
default['drupal-solr']['tomcat_home'] = "/usr/share/tomcat#{node['opsworks_java']['tomcat']['base_version']}"
default['drupal-solr']['solr_home'] = node['drupal-solr']['tomcat_home'] + "/solr"
