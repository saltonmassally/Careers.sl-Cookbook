default['drupal']['database']['name'] = ''
default['drupal']['database']['username'] = ''
default['drupal']['database']['password'] = ''
default['drupal']['database']['host'] = ''


default['drupal']['memcache']['host'] = ''
default['drupal']['memcache']['port'] = 11211

default['drupal']['hash_salt'] = ''
default['drupal']['base_url'] = ''

default[:drupal][:ebs] = {
  :aws_access_key => 'secret',
  :aws_secret_access_key => 'secret',
  :volume_id => '',
  :datadir => '',
  :mount_point => '/mnt/data',
  :device => '/dev/xvdp',
}


