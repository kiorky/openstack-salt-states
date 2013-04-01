import os
from django.utils.translation import ugettext_lazy as _

DEBUG = True
TEMPLATE_DEBUG = DEBUG
HORIZON_CONFIG = {
    'dashboards': ('nova', 'syspanel', 'settings',),
    'default_dashboard': 'nova',
}
LOCAL_PATH = os.path.dirname(os.path.abspath(__file__))

CACHE_BACKEND = 'locmem://'
SESSION_ENGINE = 'django.contrib.sessions.backends.cached_db'
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

OPENSTACK_HOST = "{{keystone_host}}"
OPENSTACK_KEYSTONE_URL = "http://%s:{{keystone_port}}/v2.0" % OPENSTACK_HOST
OPENSTACK_KEYSTONE_DEFAULT_ROLE = "Member"
OPENSTACK_KEYSTONE_BACKEND = {
    'name': 'native',
    'can_edit_user': True
}
OPENSTACK_HYPERVISOR_FEATURES = {
    'can_set_mount_point': True
}

API_RESULT_LIMIT = 1000
API_RESULT_PAGE_SIZE = 20

TIME_ZONE = "UTC"
LOGGING = {
        'version': 1,
        'disable_existing_loggers': False,
        'handlers': {
            'null': {
                'level': 'DEBUG',
                'class': 'django.utils.log.NullHandler',
                },
            'console': {
                'level': 'INFO',
                'class': 'logging.StreamHandler',
                },
            },
        'loggers': {
            'django.db.backends': {
                'handlers': ['null'],
                'propagate': False,
                },
            'horizon': {
                'handlers': ['console'],
                'propagate': False,
            },
            'openstack_dashboard': {
                'handlers': ['console'],
                'propagate': False,
            },
            'novaclient': {
                'handlers': ['console'],
                'propagate': False,
            },
            'keystoneclient': {
                'handlers': ['console'],
                'propagate': False,
            },
            'glanceclient': {
                'handlers': ['console'],
                'propagate': False,
            },
            'nose.plugins.manager': {
                'handlers': ['console'],
                'propagate': False,
            }
        }
}

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': "{{mysql_database}}",
        'USER': "{{mysql_username}}",
        'PASSWORD': "{{mysql_password}}",
        'HOST': "{{mysql_hosts[0]}}",
        'default-character-set': 'utf8'
    },
}
SWIFT_ENABLED = False
SWIFT_PAGINATE_LIMIT = 100
QUANTUM_ENABLED = False
QUANTUM_URL = '%s' % OPENSTACK_HOST
QUANTUM_PORT = '9696'
QUANTUM_TENANT = '1234'
QUANTUM_CLIENT_VERSION='0.1'
