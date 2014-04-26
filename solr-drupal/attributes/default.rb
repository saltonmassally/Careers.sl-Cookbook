default[:solr_drupal][:tomcat_user] = 'tomcat'
default[:solr_drupal][:tomcat_group] = 'tomcat'
default[:solr_drupal][:tomcat_download_link] = 'http://mirrors.sonic.net/apache/tomcat/tomcat-7/v7.0.53/bin/apache-tomcat-7.0.53.tar.gz'

default['solr_drupal']['solr_version']   = '4.7.2'
default['solr_drupal']['url']       = "http://archive.apache.org/dist/lucene/solr/" +
                                       node['solr_drupal']['solr_version'] + "/solr-" +
                                       node['solr_drupal']['solr_version']+ ".tgz"

default['solr_drupal']['tomcat_lib_dir'] = node['opsworks_java']['tomcat']['lib_dir']
default['solr_drupal']['tomcat_conf_dir'] = node['opsworks_java']['tomcat']['catalina_base_dir']
default['solr_drupal']['tomcat_webapp_dir'] = node['opsworks_java']['tomcat']['webapps_base_dir']
default['solr_drupal']['tomcat_home'] = "/usr/share/tomcat#{node['opsworks_java']['tomcat']['base_version']}"
default['solr_drupal']['solr_home'] = node['solr_drupal']['tomcat_home'] + "/solr"
