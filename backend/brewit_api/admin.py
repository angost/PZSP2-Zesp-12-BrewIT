from django.contrib import admin
from django.contrib.auth import get_user_model
from .models import Brewery, Sector, Equipment, Reservation, EquipmentReservation, Vatpackaging,\
    EqipmentReservationRequest, ReservationRequest, Recipe, ExecutionLog, BeerType, RegistrationRequest,\
    Worker

@admin.register(get_user_model())
class AccountAdmin(admin.ModelAdmin):
    list_display = ['id', 'email', 'role', 'is_active']
    list_editable = ['email', 'is_active', 'role']

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
    list_display = ['sector_id', 'name', 'allows_bacteria', 'brewery']
    list_filter = ['allows_bacteria']
    search_fields = ['name']
    list_per_page = 20
    list_max_show_all = 50
    list_editable = ['name', 'allows_bacteria']

@admin.register(Equipment)
class EquipmentAdmin(admin.ModelAdmin):
    list_display = ['equipment_id', 'selector', 'name', 'daily_price', 'description',
                    'min_temperature', 'max_temperature', 'brewery', 'sector', 'capacity']
    list_per_page = 20
    list_max_show_all = 50
    list_editable = []

@admin.register(Reservation)
class ReservationAdmin(admin.ModelAdmin):
    list_display = ['reservation_id', 'price', 'brew_size', 'production_brewery',
                     'contract_brewery', 'allows_sector_share']
    list_per_page = 20
    list_max_show_all = 50
    list_editable = []

@admin.register(EquipmentReservation)
class EquipmentReservationAdmin(admin.ModelAdmin):
    list_display = ['id', 'selector', 'start_date', 'end_date', 'equipment', 'reservation_id']
    list_per_page = 20
    list_max_show_all = 50
    list_editable = []

@admin.register(Vatpackaging)
class VatpackagingAdmin(admin.ModelAdmin):
    list_display = ['vat_packaging_id', 'equipment', 'packaging_type']
    list_per_page = 20
    list_max_show_all = 50
    list_editable = []

@admin.register(EqipmentReservationRequest)
class EqipmentReservationRequestAdmin(admin.ModelAdmin):
    list_display = ['id', 'start_date', 'end_date', 'equipment', 'reservation_request']
    list_per_page = 20
    list_max_show_all = 50
    list_editable = []

@admin.register(ReservationRequest)
class Reservation(admin.ModelAdmin):
    list_display = ['id', 'price', 'brew_size', 'production_brewery',
                     'contract_brewery', 'allows_sector_share']
    list_per_page = 20
    list_max_show_all = 50
    list_editable = []

@admin.register(Recipe)
class RecipeAdmin(admin.ModelAdmin):
    list_display = ['recipe_id', 'beer_type', 'contract_brewery', 'name', 'mashing_body',
                    'lautering_body', 'boiling_body', 'fermentation_body', 'lagerring_body']
    list_per_page = 20
    list_max_show_all = 50

@admin.register(ExecutionLog)
class ExecutionLogAdmin(admin.ModelAdmin):
    list_display = ['log_id', 'start_date', 'end_date', 'is_successful', 'recipe', 'reservation',
                    'mashing_log', 'lautering_log', 'boiling_log', 'fermentation_log', 'lagerring_log']
    list_per_page = 20
    list_max_show_all = 50
    list_editable = ['is_successful']

@admin.register(BeerType)
class BeerTypeAdmin(admin.ModelAdmin):
    list_display = ['beer_type_id', 'name', 'uses_bacteria']
    list_per_page = 20
    list_max_show_all = 50
    list_editable = ['name', 'uses_bacteria']

@admin.register(RegistrationRequest)
class RegistrationRequestAdmin(admin.ModelAdmin):
    list_display = ['id', 'email', 'role', 'selector', 'name', 'nip', 'water_ph']
    list_per_page = 20
    list_max_show_all = 50

@admin.register(Worker)
class WorkerAdmin(admin.ModelAdmin):
    list_display = ['id', 'first_name', 'last_name', 'identificator', 'brewery']
    list_per_page = 20
    list_max_show_all = 50

