'''
Created on Jul 15, 2013

@author: "Salton  Massally"
'''

DEBUG = False

TEMPLATE_DEBUG = DEBUG

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'prod_db_smssuite_careerssl',
        'USER': 'tarzan0820',
        'PASSWORD': 'nemesis20',
        'HOST': 'smssuitecareerssl.clytvrytnqp7.us-west-2.rds.amazonaws.com',
        'PORT': '3306',
    }
}




CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
        'LOCATION': '127.0.0.1:11211',
        'TIMEOUT': 3600
    }
}


# celery
BROKER_BACKEND = "SQS"
BROKER_TRANSPORT_OPTIONS = {
    'region': 'us-west-2',
}
BROKER_URL = 'sqs://'

CELERY_CACHE_BACKEND = 'memcached://127.0.0.1:11211/'
CELERY_DEFAULT_QUEUE = 'careers-sl-smssuite'
CELERY_DEFAULT_EXCHANGE = CELERY_DEFAULT_QUEUE
CELERY_DEFAULT_EXCHANGE_TYPE = CELERY_DEFAULT_QUEUE
CELERY_DEFAULT_ROUTING_KEY = CELERY_DEFAULT_QUEUE
CELERY_QUEUES = {
    CELERY_DEFAULT_QUEUE: {
        'exchange': CELERY_DEFAULT_QUEUE,
        'binding_key': CELERY_DEFAULT_QUEUE,
    }
}

RAPIDSMS_ROUTER = "rapidsms.router.db.DatabaseRouter"

CAREERS_SMS_BACKEND = 'kannel'

ALLOWED_HOSTS = [
  '54.244.251.215',
  '10.254.40.177',
  '10.255.16.238',
  '10.254.87.198',
  'ip-10-254-87-198.us-west-2.compute.internal',
]

# between what times should users be considered asleep 
# see https://github.com/pboyd/TimePeriod & http://search.cpan.org/~pryan/Period-1.20/Period.pm
SLEEP_TIME = "hour { 8pm-9am }"


# email settings
DEFAULT_FROM_EMAIL = 'developer@careers.sl'

SERVER_EMAIL = 'developer@careers.sl'

CAREERS_API_CONNECTION = {
    'host' : 'http://www.careers.sl/api/1.0/',                       
}

CAREERS_URL = 'http://www.careers.sl/'
