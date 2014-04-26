include_recipe 'python'
include_recipe 'celery'

package 'enchant'
include_recipe 'memcached'



django_path = '/path/to/smssuite/dir' # i.e. where manage.py lives

celery_opts = { "broker" => "amqp://guest:guest@localhost/%%2Fsmssuitevhost" }

celeryd_opts = {
  # have to escape the % in the vhost name with another % for supervisord
  "broker" => "amqp://guest:guest@localhost/%%2Fsmssuitevhost", 
  "concurrency" => 10,
  "queues" => "celery"
}

celery_worker "smssuite" do
  django django_path
  options celeryd_opts
end

celery_beat "smssuite" do
  django django_path
  options celery_opts
end

