package "libssl0.9.8" do
  action :install
end

service "kannel" do
  supports :status => true, :start => true, :stop => true, :restart => true
end

cookbook_file "#{Chef::Config[:file_cache_path]}/kannel_1.5.0-0_amd64.deb" do
    source "kannel_1.5.0-0_amd64.deb"
    action :create_if_missing
end

dpkg_package  "kannel" do
    source  "#{Chef::Config[:file_cache_path]}/kannel_1.5.0-0_amd64.deb"
    action :install
end

execute "ldconfig" do
  user "root"
end

group "kannel" do
   members "kannel"
   action :create
end

template "/etc/default/kannel" do
  source "kannel.erb"
  mode 0755
  owner "kannel"
  group "kannel"
  notifies :restart, "service[kannel]"
end

template "/etc/kannel/kannel.conf" do
  source "kannel.conf.erb"
  mode 0755
  owner "kannel"
  group "kannel"
  notifies :restart, "service[kannel]"
end

service "kannel" do
  action [:enable, :start]
end
