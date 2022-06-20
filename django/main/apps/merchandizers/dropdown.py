import dropdown
from django.db.models import Q
from rest_framework.exceptions import ValidationError

from main.apps.merchandizers.models import MerchandizerSetting, Shop, Product, Merchandizer, PriceTrackingSetting, \
    MerchandizerQuestion


@dropdown.register
def merchandizer_setting(query='', **kwargs):
    q = Q()
    client = kwargs.get('client')
    parent_only = kwargs.get('parent_only')
    parent = kwargs.get('parent')
    setting_type = kwargs.get('setting_type')
    merchandizer_id = kwargs.get('merchandizer')
    if query:
        q &= Q(name__icontains=query)
    if client:
        q &= Q(client=client)
    if parent_only:
        q &= Q(parent__isnull=True)
    if parent:
        q &= Q(parent=parent)
    if setting_type:
        q &= Q(type=setting_type)
    if merchandizer_id:
        q &= Q(products__merchandizer_products__merchandizer=merchandizer_id,
               products__merchandizer_products__alive=True)

    return dropdown.from_model(MerchandizerSetting, label_field='name', q_filter=q)


@dropdown.register
def merchandizer_question(query='', **kwargs):
    q = Q()
    client = kwargs.get('client')
    question_type = kwargs.get('question_type')
    active = kwargs.get('active')
    if client:
        q &= Q(client=client)
    if question_type:
        q &= Q(type=question_type)
    if active:
        q &= Q(active=active.lower() == 'true')

    return dropdown.from_model(MerchandizerQuestion, label_field='name', q_filter=q, context_fields=['active'])


@dropdown.register
def shop(query='', **kwargs):
    q = Q()
    group_only = kwargs.get('group_only')
    setting = kwargs.get('setting')
    if query:
        q &= Q(name__icontains=query)
    if group_only:
        q &= Q(setting__parent__isnull=True)
    if setting:
        q &= Q(setting=setting)

    return dropdown.from_model(Shop, label_field='name', q_filter=q)


@dropdown.register
def product(query='', **kwargs):
    q = Q()
    group_only = kwargs.get('group_only')
    setting = kwargs.get('setting')
    merchandizer_id = kwargs.get('merchandizer')
    descendants = kwargs.get('descendants')
    shop_id = kwargs.get('shop')
    if query:
        q &= Q(name__icontains=query)
    if group_only:
        q &= Q(setting__parent__isnull=True)
    if shop_id:
        q &= Q(shops=shop_id)
    if setting:
        if descendants:
            try:
                instance: MerchandizerSetting = MerchandizerSetting.objects.get(id=setting)
            except MerchandizerSetting.DoesNotExist:
                raise ValidationError({'detail': 'Setting does not exist'})
            setting_list = list(instance.get_descendants(include_self=True).values_list('id', flat=True))
            q &= Q(setting__in=setting_list)
        else:
            q &= Q(setting=setting)

    if merchandizer_id:
        q &= Q(merchandizer_products__merchandizer=merchandizer_id, merchandizer_products__alive=True)

    return dropdown.from_model(Product, label_field='name', q_filter=q)


@dropdown.register
def merchandizer(query='', **kwargs):
    q = Q()
    employee_project = kwargs.get('employee_project')
    if query:
        q &= Q(shop__name__icontains=query)
    if employee_project:
        q &= Q(employee_project=employee_project)

    return dropdown.from_model(Merchandizer, label_field='shop.name', q_filter=q)


@dropdown.register
def price_tracking_reason(query='', **kwargs):
    q = Q()
    project = kwargs.get('project')
    if project:
        q &= Q(project=project)

    return dropdown.from_model(PriceTrackingSetting, label_field='name', q_filter=q)
