from django.contrib import admin
from django.contrib.auth import get_user_model
from .models import Brewery, Sector, Equipment

# Register your models here.
@admin.register(get_user_model())
class AccountAdmin(admin.ModelAdmin):
    list_display = ['id', 'email']

@admin.register(Brewery)
class BreweryAdmin(admin.ModelAdmin):
    list_display = ['brewery_id', 'selector', 'name', 'nip', 'water_ph', 'account']
    list_filter = ['selector']
    search_fields = ['name', 'nip']
    list_per_page = 20
    list_max_show_all = 50
    list_editable = ['name', 'nip', 'water_ph']

@admin.register(Sector)
class SectorAdmin(admin.ModelAdmin):
    list_display = ['sector_id', 'name', 'allows_bacteria']
    list_filter = ['allows_bacteria']
    search_fields = ['name']
    list_per_page = 20
    list_max_show_all = 50
    list_editable = ['name', 'allows_bacteria']

@admin.register(Equipment)
class EquipmentAdmin(admin.ModelAdmin):
    list_display = ['equipment_id', 'selector', 'name', 'daily_price', 'description',
                    'min_temperature', 'max_temperature', 'brewery', 'sector']
    list_per_page = 20
    list_max_show_all = 50
    list_editable = []
