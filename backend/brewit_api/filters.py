import django_filters
from .models import Brewery, Equipment, Sector
from django_filters.rest_framework import DjangoFilterBackend
from django.db.models import Q


class EquipmentFilter(django_filters.FilterSet):

    class Meta:
        model = Equipment
        fields = ['brewery', 'sector', 'selector', 'name', 'daily_price', 'capacity']


class BreweryFilter(django_filters.FilterSet):
    water_ph = django_filters.RangeFilter()

    class Meta:
        model = Brewery
        fields = ['selector', 'name', 'water_ph']





