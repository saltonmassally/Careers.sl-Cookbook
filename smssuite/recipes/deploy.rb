include_recipe 'deploy'

node[:deploy].each do |application, deploy|
   if deploy[:application_type] != 'other'
     Chef::Log.debug("Skipping deploy::other application #{application} as it is not an other app")
     next
   end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

   bash "install_requirements" do
    code <<-EOH
    pip install -r #{deploy[:absolute_document_root]}#{node[:smssuite][:requirement_file]}
    EOH
   end

  template "#{deploy[:absolute_document_root]}node[:smssuite][:settings_file]" do
    source "settings.py.erb"
    owner deploy[:user]
    group deploy[:group]
    mode "0644"
    action :create
  end

  bash "syncdb" do
    code <<-EOH
    python #{deploy[:absolute_document_root]}manage.py syncdb --noinput
    EOH
  end

  bash "migratedb" do
    code <<-EOH
    python #{deploy[:absolute_document_root]}manage.py migrate --noinput
    EOH
  end

end

