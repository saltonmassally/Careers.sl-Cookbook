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

default[:drupal][:php][:max_execution_time] = 60
default[:drupal][:php][:memory_limit] = '256M' 
default[:drupal][:php][:error_reporting] = 'E_ALL & ~E_DEPRECATED'
default[:drupal][:php][:display_errors] = 'Off'
default[:drupal][:php][:post_max_size] = '20M'

