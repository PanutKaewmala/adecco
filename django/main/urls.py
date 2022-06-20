"""main URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
import sys

import debug_toolbar
from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import path, include
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView

urlpatterns = [
    path('backend/admin/', admin.site.urls),
    path('backend/api/', include('main.api_urls', namespace='api')),
]

TESTING = len(sys.argv) > 1 and sys.argv[1] == 'test'

if settings.DEBUG or TESTING:
    urlpatterns += [
        path('__debug__/', include(debug_toolbar.urls)),
        path('backend/api-auth/', include(('rest_framework.urls', 'api-auth'), namespace='rest_framework')),
        path('schema/', SpectacularAPIView.as_view(), name='schema'),
        path('api-docs/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
    ]

if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
