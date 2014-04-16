#
# Cookbook Name:: cookbooks/drupal
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

include_recipe 'wkhtmltopdf'

package "drush" do
  action :install
end


php_pear "pdo" do
  action :install
end

# Install APC for increased performance. rfc1867 support also provides minimal
# feedback for file uploads.  Requires pcre library.
php_pear "apc" do
  directives(:shm_size => "70M", :rfc1867 => 1)
  version "3.1.6" # TODO Somehow Chef PEAR/PECL provider causes debugging to be enabled on later builds.
  action :install
end

# Install uploadprogress for better feedback during Drupal file uploads.
php_pear "uploadprogress" do
  action :install
end




