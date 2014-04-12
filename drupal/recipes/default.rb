#
# Cookbook Name:: cookbooks/drupal
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

include_recipe %w{apache2 apache2::mod_php5 apache2::mod_rewrite apache2::mod_expires}
include_recipe %w{php php::module_mysql php::module_gd}
include_recipe "postfix"
include_recipe "drupal::drush"
include_recipe "drupal::cron"

execute "disable-default-site" do
   command "sudo a2dissite default"
   notifies :reload, "service[apache2]", :delayed
   only_if do File.exists? "#{node['apache']['dir']}/sites-enabled/default" end
end

cookbook_file "drupal" do
  path "/etc/apache2/sites-available/drupal"
end

execute "a2ensite drupal" do
  creates "/etc/apache2/sites-enabled/drupal"
  notifies :restart, "service[apache2]"
end

