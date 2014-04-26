#
# Cookbook Name:: postfix-ses
# Recipe:: default
#
# Copyright (C) 2013 TABLE XI
# 
# All rights reserved - Do Not Redistribute
#
package 'java7-jdk'

group node[:solr_default][:tomcat_group]

bash "change_owner" do
  code <<-EOH
    useradd -Mb /usr/local #{node[:solr_default][:tomcat_user]} -g #{node[:solr_default][:tomcat_group]}
  EOH
end

ark 'tomcat' do
   url node[:solr_default][:tomcat_download_link]
   owner node[:solr_default][:tomcat_user]
   action :put
end
