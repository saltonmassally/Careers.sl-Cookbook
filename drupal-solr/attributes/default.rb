## Cookbook Name:: drupal-solr
## Attribute:: default

# must be one of the versions available at http://archive.apache.org/dist/lucene/solr/
# must be consistent with node['drupal-solr']['apachesolr_conf_dir']


default['drupal-solr']['solr_version']   = '4.7.1'
default['drupal-solr']['url']       = "http://archive.apache.org/dist/lucene/solr/" +
                                       node['drupal-solr']['solr_version'] + "/solr-" +
                                       node['drupal-solr']['solr_version']+ ".tgz"
default["solr_app"]["archive_war_path"] = ::File.join("solr-#{node['drupal-solr']['solr_version']}", "dist", "solr-#{['drupal-solr']['solr_version']}.war")
default['drupal-solr']['app_name']  = "solr"
default['drupal-solr']['log_format'] = "common"
default['drupal-solr']['custom_conf_file'] = ''
default['drupal-solr']['war_dir']   = "/opt/solr"
default['drupal-solr']['home_dir']  = "/opt/solr/#{node['drupal-solr']['app_name']}"
default['drupal-solr']['tomcat_user'] = node['opsworks_java']['tomcat']['user']
default['drupal-solr']['tomcat_group'] = node['opsworks_java']['tomcat']['group']

# Logic based on the following:
#   http://drupalcode.org/project/apachesolr.git/blob/refs/heads/5.x-2.x:/schema.xml
#   http://drupalcode.org/project/apachesolr.git/blob/refs/heads/6.x-1.x:/schema.xml
#   http://drupalcode.org/project/apachesolr.git/blob/refs/heads/6.x-2.x:/schema.xml
#   http://drupalcode.org/project/apachesolr.git/tree/refs/heads/6.x-3.x:/solr-conf
#   http://drupalcode.org/project/apachesolr.git/tree/refs/heads/7.x-1.x:/solr-conf
def getSolrConfPath(drupalVersion, solrVersion)
  if drupalVersion.match /^6.x-3|^7|^8/  # newer versions
    path = case solrVersion
      when /1\.4/ then '/solr-conf/solr-1.4/*'
      when /3\./ then '/solr-conf/solr-3.x/*'
      when /4\./ then '/solr-conf/solr-4.x/*'
      else raise "Unsupported solr version"
    end
  else # older versions
    path = './{protwords.txt,schema.xml,solrconfig.xml}'
  end
  return path
end

default['drupal-solr']['conf_source_glob'] = getSolrConfPath(node['drupal-solr']['module_version'], node['drupal-solr']['solr_version'])
