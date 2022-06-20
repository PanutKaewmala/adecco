from rest_framework import serializers

from main.apps.common.constants import EXCLUDE_SOFT_DELETE_FIELD
from main.apps.merchandizers.models import MerchandizerQuestion


class MerchandizerQuestionSerializer(serializers.ModelSerializer):
    class Meta:
        model = MerchandizerQuestion
        exclude = EXCLUDE_SOFT_DELETE_FIELD
