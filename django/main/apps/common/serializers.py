from drf_writable_nested import NestedCreateMixin, NestedUpdateMixin
from rest_flex_fields.serializers import FlexFieldsSerializerMixin
from rest_framework import serializers


class FlexedWritableNestedModelSerializer(FlexFieldsSerializerMixin, NestedCreateMixin, NestedUpdateMixin,
                                          serializers.ModelSerializer):
    pass
