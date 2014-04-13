## Cookbook Name:: drupal-solr
## Recipe:: default
##

include_recipe "drupal-solr::install_solr"




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


