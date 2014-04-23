aws_ebs_volume "drupal_data_volume" do
  aws_access_key node[:drupal][:ebs][:aws_access_key]
  aws_secret_access_key node[:drupal][:ebs][:aws_secret_access_key]
  volume_id node[:drupal][:ebs][:volume_id]
  device node[:drupal][:ebs][:device]
  action :attach
end

directory node[:drupal][:ebs][:mount_point] do
   mode '0755'
   owner deploy[:user]
   group deploy[:group]
   recursive true
 end

mount node[:drupal][:ebs][:mount_point] do
  device node[:drupal][:ebs][:device]
  options "rw noatime"
  fstype "xfs"
  action [ :enable, :mount ]
  # Do not execute if its already mounted
  not_if "cat /proc/mounts | grep #{node[:drupal][:ebs][:mount_point]}"
end

