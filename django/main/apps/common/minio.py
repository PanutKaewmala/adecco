from django.core.files.storage import Storage
from django_minio_backend import MinioBackend

from main.settings import CI_TESTING


class SwitchMinioBackend(MinioBackend):
    """
        this class for switch when ci test django. no service minio will use all method in class Storage.
    """

    def __init__(self,
                 bucket_name: str = '',
                 *args,
                 **kwargs):  # pylint: disable=keyword-arg-before-vararg
        if CI_TESTING:
            Storage.__init__(self)  # pylint: disable=non-parent-init-called
        else:
            super().__init__(bucket_name, args, kwargs)

    def get_available_name(self, name, max_length=None):
        if CI_TESTING:
            Storage.get_available_name(self, name, max_length)
        else:
            return super().get_available_name(name, max_length)

    def path(self, name):
        if CI_TESTING:
            Storage.path(self, name)
        else:
            super().path(name)

    def delete(self, name: str):
        if CI_TESTING:
            Storage.delete(self, name)
        else:
            super().delete(name)

    def exists(self, name: str) -> bool:
        if CI_TESTING:
            return Storage.exists(self, name)
        else:
            return super().exists(name)

    def listdir(self, bucket_name):
        if CI_TESTING:
            Storage.listdir(self, bucket_name)
        else:
            return super().listdir(bucket_name)

    def size(self, name: str) -> int:
        if CI_TESTING:
            return Storage.size(self, name)
        else:
            return super().size(name)

    def url(self, name: str):
        if CI_TESTING:
            Storage.url(self, name)
        else:
            return super().url(name)

    def get_accessed_time(self, name):
        if CI_TESTING:
            Storage.get_accessed_time(self, name)
        else:
            super().get_accessed_time(name)

    def get_created_time(self, name):
        if CI_TESTING:
            Storage.get_created_time(self, name)
        else:
            super().get_created_time(name)

    def get_modified_time(self, name):
        if CI_TESTING:
            Storage.get_modified_time(self, name)
        else:
            return super().get_modified_time(name)
