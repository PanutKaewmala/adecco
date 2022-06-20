"""
Django settings for main project.

Generated by 'django-admin startproject' using Django 3.0.7.

For more information on this file, see
https://docs.djangoproject.com/en/3.0/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/3.0/ref/settings/
"""

import os
import sys
import typing
from datetime import timedelta

import environ
import redis
import sentry_sdk
from django.utils.translation import gettext_lazy as _
from sentry_sdk.integrations.celery import CeleryIntegration
from sentry_sdk.integrations.django import DjangoIntegration

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

env = environ.Env()
ROOT_DIR = environ.Path(__file__) - 3

# Detect test environment
TESTING = 'test' in sys.argv

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/3.0/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = env.str(var='DJANGO_SECRET_KEY', default='%=18z@)(d^%t+8yx&t5o)bd4aez(#owrxgch9o^v)u%k3mw9%#')

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = env.bool(var='DJANGO_DEBUG', default=False)
MINIO = env.bool(var='USE_MINIO', default=False)
ALLOWED_HOSTS = env.list(var='DJANGO_ALLOWED_HOSTS', default=['*'])

# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
]

LOCAL_APPS = [
    'main.apps.activities',
    'main.apps.authentication',
    'main.apps.common',
    'main.apps.managements',
    'main.apps.users',
    'main.apps.rosters',
    'main.apps.merchandizers'
]

THIRD_PARTY_APPS = [
    'rest_framework',
    'django_filters',
    'corsheaders',
    'django_extensions',
    'drf_spectacular',
]

if MINIO:
    THIRD_PARTY_APPS.append('django_minio_backend.apps.DjangoMinioBackendConfig')


INSTALLED_APPS += LOCAL_APPS + THIRD_PARTY_APPS

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.locale.LocaleMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'main.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'main.wsgi.application'

# Database
# https://docs.djangoproject.com/en/3.0/ref/settings/#databases
# Database configuration
DATABASES = {
    'default': env.db(
        var='DATABASE_URL',
        default='postgres://postgres:Codium123!@postgres:5432/db'
    ),
}
DATABASES['default']['ATOMIC_REQUESTS'] = True

# Auto field type
# https://docs.djangoproject.com/en/3.2/releases/3.2/#customizing-type-of-auto-created-primary-keys
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# Custom user model
# https://docs.djangoproject.com/en/3.2/topics/auth/customizing/#substituting-a-custom-user-model
AUTH_USER_MODEL = 'users.User'

# Password validation
# https://docs.djangoproject.com/en/3.0/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

# Internationalization
# https://docs.djangoproject.com/en/3.0/topics/i18n/

LANGUAGE_CODE = 'en'

LANGUAGES = (
    ('en', _('English')),
    ('th', _('Thai')),
)

LOCALE_PATHS = [
    os.path.join(BASE_DIR, 'locale'),
]

TIME_ZONE = 'Asia/Bangkok'

USE_I18N = True

USE_L10N = True

USE_TZ = True

# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/3.0/howto/static-files/

STATIC_URL = '/static/'
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
STATICFILES_DIRS = [
    os.path.join(BASE_DIR, 'static'),
]

# Media files

MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join('media')

# Password hasher
# for fast testing
if TESTING:
    PASSWORD_HASHERS = [
        'django.contrib.auth.hashers.MD5PasswordHasher',
    ]

# Testing
# Test runner for CI
CI_TESTING = env.bool('CI_TESTING', default=False)
if CI_TESTING:
    TEST_RUNNER = 'xmlrunner.extra.djangotestrunner.XMLTestRunner'
    TEST_OUTPUT_DIR = 'result'
    TEST_OUTPUT_FILE_NAME = 'report.xml'

# HTTPS and Proxy server setting
#
# Proxy server settings: Hey, Django, whenever you get an "X_Forwarded_Proto"
# in the HTTP request, it means a HTTPS request was sent to the proxy server
# by the end users
USE_SSL = env.bool('USE_SSL', default=False)
if USE_SSL:
    SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
    SECURE_SSL_REDIRECT = True
    SESSION_COOKIE_SECURE = True
    CSRF_COOKIE_SECURE = True
    CSRF_COOKIE_HTTPONLY = True

# Django REST Framework Cors Header Origin
# https://github.com/adamchainz/django-cors-headers
CORS_ORIGIN_ALLOW_ALL = DEBUG
CORS_ORIGIN_WHITELIST = env.list(
    var='CORS_ORIGIN_WHITELIST',
    default=['http://localhost:4200']
)

# Django Rest Framework settings
# http://www.django-rest-framework.org/api-guide/settings/
authentication_classes = (
    'rest_framework_simplejwt.authentication.JWTAuthentication',
)
renderer_classes = (
    'rest_framework.renderers.JSONRenderer',
)
if DEBUG or TESTING:
    authentication_classes += (
        # Session Authentication use for Web browsable API and force_login in tests
        'rest_framework.authentication.SessionAuthentication',
    )
if DEBUG:
    authentication_classes += (
        # Usually Basic Authentication not have any use case for production environment,
        # then it should enable when debugging
        'rest_framework.authentication.BasicAuthentication',
    )
    renderer_classes += (
        # Usually Web browsable API not have any use case for production environment,
        # then it should enable when debugging
        'rest_framework.renderers.BrowsableAPIRenderer',
    )

    INSTALLED_APPS += [
        'debug_toolbar',
    ]

    MIDDLEWARE += [
        'debug_toolbar.middleware.DebugToolbarMiddleware',
    ]

    DEBUG_TOOLBAR_CONFIG = {
        'SHOW_TOOLBAR_CALLBACK': lambda _request: DEBUG
    }

if MINIO:
    MINIO_ENDPOINT = os.environ.get('MINIO_ENDPOINT', 'minio:9000')
    MINIO_EXTERNAL_ENDPOINT = os.environ.get('MINIO_EXTERNAL_ENDPOINT', 'localhost:9000')
    MINIO_EXTERNAL_ENDPOINT_USE_HTTPS = env.bool(var='MINIO_EXTERNAL_ENDPOINT_USE_HTTPS', default=True)
    MINIO_ACCESS_KEY = os.environ.get('MINIO_ACCESS_KEY', 'adecco')
    MINIO_SECRET_KEY = os.environ.get('MINIO_SECRET_KEY', 'Codium123!')
    MINIO_USE_HTTPS = env.bool(var='MINIO_USE_HTTPS', default=True)
    MINIO_URL_EXPIRY_HOURS = timedelta(days=1)  # Default is 7 days (longest) if not defined
    MINIO_CONSISTENCY_CHECK_ON_START = False
    MINIO_PRIVATE_BUCKETS = [
        'django-media',
    ]
    MINIO_PUBLIC_BUCKETS = [
        'django-static'
    ]
    MINIO_POLICY_HOOKS: typing.List[typing.Tuple[str, dict]] = []
    MINIO_BUCKET_CHECK_ON_SAVE = True  # Default: True // Creates bucket if missing, then save
    STATICFILES_STORAGE = 'django_minio_backend.models.MinioBackendStatic'
    MINIO_STATIC_FILES_BUCKET = 'django-static'  # replacement for STATIC_ROOT


REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': authentication_classes,
    'DEFAULT_FILTER_BACKENDS': (
        'django_filters.rest_framework.DjangoFilterBackend',
    ),
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticated',
    ),
    'DEFAULT_RENDERER_CLASSES': renderer_classes,
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 40,
    'COERCE_DECIMAL_TO_STRING': False,
    'DEFAULT_SCHEMA_CLASS': 'drf_spectacular.openapi.AutoSchema',
}

# Django simple JWT settings
# https://django-rest-framework-simplejwt.readthedocs.io/en/latest/settings.html
SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(days=30),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=365),
    'ROTATE_REFRESH_TOKENS': False,
    'BLACKLIST_AFTER_ROTATION': True,

    'ALGORITHM': 'HS256',
    'SIGNING_KEY': SECRET_KEY,
    'VERIFYING_KEY': None,
    'AUDIENCE': None,
    'ISSUER': None,

    'AUTH_HEADER_TYPES': ('Bearer',),
    'USER_ID_FIELD': 'id',
    'USER_ID_CLAIM': 'user_id',

    'AUTH_TOKEN_CLASSES': ('rest_framework_simplejwt.tokens.AccessToken',),
    'TOKEN_TYPE_CLAIM': 'token_type',

    'JTI_CLAIM': 'jti',

    'SLIDING_TOKEN_REFRESH_EXP_CLAIM': 'refresh_exp',
    'SLIDING_TOKEN_LIFETIME': timedelta(minutes=5),
    'SLIDING_TOKEN_REFRESH_LIFETIME': timedelta(days=1),
}

# redis
if not TESTING:
    REDIS_HOST = env.str('REDIS_HOST', 'redis://redis:6379/0')
    REDIS_POOL = redis.ConnectionPool.from_url(REDIS_HOST)

# celery
if not TESTING:
    CELERY_REDIS_HOST = env.str('CELERY_REDIS_HOST', 'redis://redis:6379/1')
    CELERY_BROKER_URL = CELERY_REDIS_HOST
    CELERY_RESULT_BACKEND = CELERY_REDIS_HOST
    CELERY_ACCEPT_CONTENT = ['application/json']
    CELERY_RESULT_SERIALIZER = 'json'
    CELERY_TASK_SERIALIZER = 'json'
    CELERY_TIMEZONE = 'Asia/Bangkok'
    CELERY_TASK_TRACK_STARTED = True

# caching
if TESTING:
    CACHES = {
        'default': {
            'BACKEND': 'django.core.cache.backends.dummy.DummyCache',
        }
    }
else:
    CACHES = {
        'default': {
            'BACKEND': 'django_redis.cache.RedisCache',
            'LOCATION': 'redis://redis:6379/2',
            'OPTIONS': {
                'CLIENT_CLASS': 'django_redis.client.DefaultClient',
            },
        }
    }

# email
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = env.str('EMAIL_HOST', 'mail')
EMAIL_HOST_USER = env.str('EMAIL_HOST_USER', '')
EMAIL_HOST_PASSWORD = env.str('EMAIL_HOST_PASSWORD', '')
EMAIL_PORT = env.int('EMAIL_PORT', 1025)
EMAIL_USE_TLS = env.bool('EMAIL_USE_TLS', False)
EMAIL_SENDER_NAME = env.str('EMAIL_SENDER_NAME', 'CODIUM <system@codium.co>')
ALLOWED_EMAIL_DOMAINS = env.list('ALLOWED_EMAIL_DOMAINS', default=['*'])  # Email address validator

# sentry
sentry_sdk.init(  # pylint: disable=abstract-class-instantiated
    integrations=[DjangoIntegration(), CeleryIntegration()],
    send_default_pii=True,
)

# API Docs settings
SPECTACULAR_SETTINGS = {
    'TITLE': 'Adecco API',
    'DESCRIPTION': 'Adecco project API Documents',
    'VERSION': '1.0.0',
    'SCHEMA_PATH_PREFIX': '/backend/api/*',
    'SERVE_PERMISSIONS': ['rest_framework.permissions.IsAuthenticated'],
    'DISABLE_ERRORS_AND_WARNINGS': True,
}
