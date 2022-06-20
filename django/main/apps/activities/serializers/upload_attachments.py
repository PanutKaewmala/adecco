from rest_framework import serializers

from main.apps.activities.models import LeaveRequest, UploadAttachment
from main.apps.common.serializers import FlexedWritableNestedModelSerializer


class UploadBulkAttachmentSerializer(serializers.Serializer):
    leave_request = serializers.PrimaryKeyRelatedField(queryset=LeaveRequest.objects.all())
    file = serializers.FileField(required=False)


class UploadAttachmentSerializer(FlexedWritableNestedModelSerializer):
    class Meta:
        model = UploadAttachment
        fields = ['id', 'name', 'file', 'leave_request']
        extra_kwargs = {
            'name': {'required': False}
        }


class UploadAttachmentReadSerializer(UploadAttachmentSerializer):
    class Meta(UploadAttachmentSerializer.Meta):
        fields = UploadAttachmentSerializer.Meta.fields + ['name']
