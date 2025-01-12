# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = True` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models
from django.conf import settings
from django.contrib.auth.models import AbstractUser
from django.utils.translation import gettext_lazy as _
from .managers import CustomUserManager

class Account(AbstractUser):
    class AccountRoles(models.TextChoices):
        PRODUCTION = 'PROD', _('Production Brewery')
        CONTRACT = 'CONTR', _('Contract Brewery')
        ADMIN = 'ADMIN', _('Administrator')

    username = None
    email = models.EmailField(_("email address"), unique=True)
    role = models.CharField(
        max_length=5,
        choices=AccountRoles.choices,
        blank=False
    )

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ['role']

    objects = CustomUserManager()

    def __str__(self):
        return self.email

    def get_brewery(self):
        try:
            return self.breweries.get()
        except:
            return None


class BeerType(models.Model):
    beer_type_id = models.AutoField(primary_key=True)
    name = models.CharField(unique=True, max_length=32)
    uses_bacteria = models.BooleanField()

    class Meta:
        managed = True
        db_table = 'beer_type'


class Brewery(models.Model):
    class BrewerySelectors(models.TextChoices):
        PRODUCTION = 'PROD', _('Production Brewery')
        CONTRACT = 'CONTR', _('Contract Brewery')

    brewery_id = models.AutoField(primary_key=True)
    selector = models.CharField(max_length=10,
                                choices=BrewerySelectors.choices,
                                blank=False)
    name = models.CharField(max_length=128)
    nip = models.CharField(max_length=10, blank=True, null=True)
    water_ph = models.DecimalField(max_digits=3, decimal_places=1, blank=True, null=True)
    account = models.ForeignKey(settings.AUTH_USER_MODEL, models.DO_NOTHING, related_name='breweries')

    class Meta:
        managed = True
        db_table = 'brewery'


class RegistrationRequest(models.Model):
    email = models.EmailField(_("email address"))
    role = models.CharField(
        max_length=5,
        choices=Account.AccountRoles.choices,
        blank=False
    )
    password = models.CharField()
    selector = models.CharField(max_length=10,
                                choices=Brewery.BrewerySelectors.choices,
                                blank=False)
    name = models.CharField(max_length=128)
    nip = models.CharField(max_length=10, blank=True, null=True)
    water_ph = models.DecimalField(max_digits=3, decimal_places=1, blank=True, null=True)

class Sector(models.Model):
    sector_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=32)
    allows_bacteria = models.BooleanField()
    brewery = models.ForeignKey(Brewery, models.DO_NOTHING, related_name='sectors')

    class Meta:
        managed = True
        db_table = 'sector'


class Equipment(models.Model):
    class EquipmentSelectors(models.TextChoices):
        VAT = 'VAT', _('Vat')
        BREWSET = 'BREWSET', _('Brewing Set')
    equipment_id = models.AutoField(primary_key=True)
    selector = models.CharField(max_length=10,
                                choices=EquipmentSelectors.choices,
                                blank=False)
    capacity = models.IntegerField()
    name = models.CharField(max_length=32)
    daily_price = models.DecimalField(max_digits=10, decimal_places=2)
    description = models.CharField(max_length=512, blank=True, null=True)
    min_temperature = models.DecimalField(max_digits=5, decimal_places=2, blank=True, null=True)
    max_temperature = models.DecimalField(max_digits=5, decimal_places=2, blank=True, null=True)
    brewery = models.ForeignKey(Brewery, models.DO_NOTHING, related_name='equipment')
    sector = models.ForeignKey('Sector', models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'equipment'


class Recipe(models.Model):
    recipe_id = models.AutoField(primary_key=True)
    recipe_body = models.CharField(max_length=2048, blank=True, null=True)
    beer_type = models.ForeignKey(BeerType, models.DO_NOTHING)
    contract_brewery = models.ForeignKey(Brewery, models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'recipe'


class ReservationRequest(models.Model):
    price = models.IntegerField()
    brew_size = models.IntegerField()
    authorised_workers = models.CharField(max_length=512, blank=True, null=True)
    production_brewery = models.ForeignKey(Brewery, models.DO_NOTHING)
    contract_brewery = models.ForeignKey(Brewery, models.DO_NOTHING, related_name='reservation_requests_contract')
    allows_sector_share = models.BooleanField()
    # uses_bacteria = models.BooleanField() idk


class EqipmentReservationRequest(models.Model):
    start_date = models.DateTimeField()
    end_date = models.DateTimeField()
    equipment = models.ForeignKey(Equipment, models.DO_NOTHING, related_name='equipment_reservation_requests')
    reservation_request = models.ForeignKey(ReservationRequest, models.CASCADE, related_name='equipment_reservation_requests')


class Reservation(models.Model):
    reservation_id = models.AutoField(primary_key=True)
    price = models.IntegerField()
    brew_size = models.IntegerField()
    authorised_workers = models.CharField(max_length=512, blank=True, null=True)
    production_brewery = models.ForeignKey(Brewery, models.DO_NOTHING, related_name='reservation_production_brewery')
    contract_brewery = models.ForeignKey(Brewery, models.DO_NOTHING, related_name='reservation_contract_brewery')
    allows_sector_share = models.BooleanField()

    class Meta:
        managed = True
        db_table = 'reservation'


class EquipmentReservation(models.Model):
    class EquipmentSelectors(models.TextChoices):
        CLEAN = 'CLEAN', _('Cleaning')
        BREW = 'BREW', _('Brewing')
    selector = models.CharField(max_length=10,
                                choices=EquipmentSelectors.choices,
                                blank=False)
    start_date = models.DateTimeField()
    end_date = models.DateTimeField()
    equipment = models.ForeignKey(Equipment, models.DO_NOTHING, related_name='reservations')
    reservation_id = models.ForeignKey(Reservation, models.CASCADE, blank=True, null=True, related_name='equipment_reservations')

    class Meta:
        managed = True
        db_table = 'equipment_reservation'


class ExecutionLog(models.Model):
    log_id = models.AutoField(primary_key=True)
    start_date = models.DateTimeField()
    end_date = models.DateTimeField(blank=True, null=True)
    is_successful = models.BooleanField(blank=True, null=True)
    log = models.CharField(max_length=2048, blank=True, null=True)
    recipe = models.ForeignKey('Recipe', models.DO_NOTHING)
    reservation = models.ForeignKey('Reservation', models.DO_NOTHING, related_name='execution_logs')

    class Meta:
        managed = True
        db_table = 'execution_log'


class Vatpackaging(models.Model):
    class PackagingTypes(models.TextChoices):
        BOTTLE = 'BOTTLE', _('Bottle')
        CAN = 'CAN', _('Can')
        KEG = 'KEG', _('Keg')
    vat_packaging_id = models.AutoField(primary_key=True)
    equipment = models.ForeignKey(Equipment, models.DO_NOTHING, related_name='vat_packaging')
    packaging_type = models.CharField(max_length=10,
                                      choices=PackagingTypes.choices,
                                      blank=False)
    class Meta:
        managed = True
        db_table = 'vatpackaging'
