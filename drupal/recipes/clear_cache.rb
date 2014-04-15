
bash 'clear_cache' do
  code <<-EOH
    drush cache-clear
    EOH
  not_if { node['drupal']['dir'] }
end
