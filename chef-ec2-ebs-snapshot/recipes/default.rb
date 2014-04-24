#
# Cookbook Name:: ec2-consistent-snapshot
# Recipe:: default
#

bash "update_ppa" do
    code <<-EOH
    add-apt-repository ppa:alestic 
    apt-get update
    EOH
end

package 'ec2-consistent-snapshot'

package 'ec2-expire-snapshots'

template "/usr/bin/snapshot_create.sh" do
  source "snapshot_create.sh.erb"
  owner    "root"
  group    "root"
  mode     "0700"
end

template "/usr/bin/snapshot_delete.sh" do
  source "snapshot_delete.sh.erb"
  owner    "root"
  group    "root"
  mode     "0700"
end

directory '/var/log/snapshotting' do
  mode '0777'
  owner "root"
  group "root"
end

file "/var/log/snapshotting/backup-create.log" do
  owner "root"
  group "root"
  mode "0777"
  action :create
end

file "/var/log/snapshotting/backup-delete.log" do
  owner "root"
  group "root"
  mode "0777"
  action :create
end

cron "snapshot_create_cron" do
   command "snapshot_create.sh >> /var/log/snapshotting/backup-create.log"
   hour "*/12"
   minute "0"
   only_if  { File.exist?("/usr/bin/snapshot_create.sh") }
end

cron "snapshot_delete_cron" do
   command "snapshot_create.sh >> /var/log/snapshotting/backup-delete.log"
   hour "3"
   minute "0"
   only_if  { File.exist?("/usr/bin/snapshot_create.sh") }
end
