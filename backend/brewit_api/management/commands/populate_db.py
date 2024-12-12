from datetime import datetime, timedelta
from django.core.management.base import BaseCommand
from django.utils import timezone
from django.contrib.auth.hashers import make_password

from brewit_api.models import (
    BrewerySelectors, Account, BeerType, Brewery, Sector, Equipment,
    EquipmentReservation, Recipe, Reservation, ExecutionLog, Packagingtype,
    Vatpackaging
)

class Command(BaseCommand):
    help = "Populates the database with sample data."

    def handle(self, *args, **kwargs):
        self.create_accounts()
        self.create_beer_types()
        self.create_breweries()
        self.create_sectors()
        self.create_equipment()
        self.create_equipment_reservations()
        self.create_reservations()
        self.create_recipes()
        self.create_execution_logs()
        self.create_packaging_types()
        self.create_vat_packaging()
        self.stdout.write(self.style.SUCCESS('Sample data successfully created!'))

    def create_accounts(self):
        if Account.objects.exists():
            return

        Account.objects.create_superuser(email='admin@example.com', password='admin')

        Account.objects.bulk_create([
            Account(email='user1@example.com', password=make_password('user1')),
            Account(email='user2@example.com', password=make_password('user2')),
            Account(email='user3@example.com', password=make_password('user3')),
        ])
        print('Accounts created.')

    def create_beer_types(self):
        if BeerType.objects.exists():
            return

        BeerType.objects.bulk_create([
            BeerType(name='Lager', uses_bacteria=False),
            BeerType(name='Ale', uses_bacteria=False),
            BeerType(name='Sour', uses_bacteria=True),
        ])
        print('Beer types created.')

    def create_breweries(self):
        if Brewery.objects.exists():
            return

        accounts = Account.objects.all()
        Brewery.objects.bulk_create([
            Brewery(selector='PROD', name='Brewery1', nip='1234567890', water_ph=7, account=accounts[0]),
            Brewery(selector='CONTR', name='Contract1', nip='0987654321', account=accounts[1]),
            Brewery(selector='CONTR', name='Contract2', nip='1221377231', account=accounts[2]),
        ])
        print('Breweries created.')

    def create_sectors(self):
        if Sector.objects.exists():
            return

        Sector.objects.bulk_create([
            Sector(name='Fermentation', allows_bacteria=True),
            Sector(name='Bottling', allows_bacteria=False),
        ])
        print('Sectors created.')

    def create_equipment(self):
        if Equipment.objects.exists():
            return

        breweries = Brewery.objects.all()
        sectors = Sector.objects.all()

        Equipment.objects.bulk_create([
            Equipment(selector='VAT', capacity=500, name='Fermenter 1', daily_price=150.00, min_temperature=15, max_temperature=40, brewery=breweries[0], sector=sectors[0]),
            Equipment(selector='BREWSET', capacity=300, name='Bottling Line 1', daily_price=100.00, brewery=breweries[0], sector=sectors[1]),
        ])
        print('Equipment created.')

    def create_equipment_reservations(self):
        if EquipmentReservation.objects.exists():
            return

        equipment = Equipment.objects.all()

        start_date = timezone.now()
        end_date_brew = start_date + timedelta(days=14)
        end_date_clean = end_date_brew + timedelta(days=2)
        EquipmentReservation.objects.bulk_create([
            EquipmentReservation(selector='BREW', start_date=start_date, end_date=end_date_brew, equipment=equipment[0]),
            EquipmentReservation(selector='CLEAN', start_date=end_date_brew, end_date=end_date_clean, equipment=equipment[0]),
        ])
        print('Equipment reservations created.')

    def create_reservations(self):
        if Reservation.objects.exists():
            return

        breweries = Brewery.objects.all()
        Reservation.objects.bulk_create([
            Reservation(price=5000, brew_size=1000, authorised_workers='Alice, Bob', production_brewery=breweries[0], contract_brewery=breweries[1]),
        ])
        print('Reservations created.')

    def create_recipes(self):
        if Recipe.objects.exists():
            return

        beer_types = BeerType.objects.all()
        breweries = Brewery.objects.all()
        Recipe.objects.bulk_create([
            Recipe(recipe_body='Add hops and yeast. Ferment for 2 weeks.', beer_type_beer=beer_types[0], contract_brewery_brewery=breweries[1]),
        ])
        print('Recipes created.')

    def create_execution_logs(self):
        if ExecutionLog.objects.exists():
            return

        recipes = Recipe.objects.all()
        reservations = Reservation.objects.all()
        ExecutionLog.objects.bulk_create([
            ExecutionLog(start_date=timezone.now(), end_date=timezone.now() + timedelta(days=2), is_successful=True, log='Batch completed.', recipe=recipes[0], reservation=reservations[0]),
        ])
        print('Execution logs created.')

    def create_packaging_types(self):
        if Packagingtype.objects.exists():
            return

        Packagingtype.objects.bulk_create([
            Packagingtype(name='Bottle'),
            Packagingtype(name='Can'),
        ])
        print('Packaging types created.')

    def create_vat_packaging(self):
        if Vatpackaging.objects.exists():
            return

        equipment = Equipment.objects.all()
        packaging_types = Packagingtype.objects.all()
        Vatpackaging.objects.bulk_create([
            Vatpackaging(equipment=equipment[0], packaging_type=packaging_types[0]),
        ])
        print('Vat packaging created.')

