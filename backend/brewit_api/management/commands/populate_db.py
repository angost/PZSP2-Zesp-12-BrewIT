from datetime import datetime, timedelta
from django.core.management.base import BaseCommand
from django.utils import timezone
from django.contrib.auth.hashers import make_password

from brewit_api.models import (
    Account, BeerType, Brewery, Sector, Equipment,
    EquipmentReservation, Recipe, Reservation, ExecutionLog, Vatpackaging,
    Worker
)

class Command(BaseCommand):
    help = "Populates the database with sample data."

    def handle(self, *args, **kwargs):
        self.create_accounts()
        self.create_beer_types()
        self.create_breweries()
        self.create_workers()
        self.create_sectors()
        self.create_equipment()
        self.create_reservations()
        self.create_equipment_reservations()
        self.create_recipes()
        self.create_execution_logs()
        self.create_vat_packaging()
        self.stdout.write(self.style.SUCCESS('Sample data successfully created!'))

    def create_accounts(self):
        if Account.objects.exists():
            return

        Account.objects.bulk_create([
            Account(email='prod1@example.com', password=make_password('prod1'), role=Account.AccountRoles.PRODUCTION),
            Account(email='prod2@example.com', password=make_password('prod2'), role=Account.AccountRoles.PRODUCTION),
            Account(email='prod3@example.com', password=make_password('prod3'), role=Account.AccountRoles.PRODUCTION),
            Account(email='contr1@example.com', password=make_password('contr1'), role=Account.AccountRoles.CONTRACT),
            Account(email='contr2@example.com', password=make_password('contr2'), role=Account.AccountRoles.CONTRACT),
            Account(email='contr3@example.com', password=make_password('contr3'), role=Account.AccountRoles.CONTRACT),
        ])

        Account.objects.create_superuser(email='admin@example.com', password='admin', role=Account.AccountRoles.ADMIN)
        print('Accounts created.')

    def create_beer_types(self):
        if BeerType.objects.exists():
            return

        beer_types = [
            BeerType(name='Lager', uses_bacteria=False),
            BeerType(name='Ale', uses_bacteria=False),
            BeerType(name='Sour', uses_bacteria=True),
            BeerType(name='Stout', uses_bacteria=False),
            BeerType(name='Porter', uses_bacteria=False),
            BeerType(name='IPA', uses_bacteria=False),
            BeerType(name='Gose', uses_bacteria=True),
            BeerType(name='Berliner Weisse', uses_bacteria=True),
            BeerType(name='Wheat Beer', uses_bacteria=False),
            BeerType(name='Pilsner', uses_bacteria=False),
            BeerType(name='Barleywine', uses_bacteria=False),
            BeerType(name='Belgian Tripel', uses_bacteria=False),
            BeerType(name='Lambic', uses_bacteria=True),
            BeerType(name='Saison', uses_bacteria=False),
            BeerType(name='Kolsch', uses_bacteria=False),
            BeerType(name='Different with bacteria', uses_bacteria=True),
            BeerType(name='Different without bacteria', uses_bacteria=False),
        ]
        BeerType.objects.bulk_create(beer_types)
        print('Beer types created.')

    def create_breweries(self):
        if Brewery.objects.exists():
            return

        accounts = Account.objects.all()
        Brewery.objects.bulk_create([
            Brewery(selector='PROD', name='Prod1', nip='1234567890', water_ph=6, account=accounts[0]),
            Brewery(selector='PROD', name='Prod2', nip='1234567890', water_ph=7, account=accounts[1]),
            Brewery(selector='PROD', name='Prod3', nip='1234567890', water_ph=8, account=accounts[2]),
            Brewery(selector='CONTR', name='Contract1', nip='0987654321', account=accounts[3]),
            Brewery(selector='CONTR', name='Contract2', nip='1221377231', account=accounts[4]),
            Brewery(selector='CONTR', name='Contract3', nip='1221377231', account=accounts[5]),
        ])
        print('Breweries created.')

    def create_workers(self):
        if Worker.objects.exists():
            return

        breweries = Brewery.objects.filter(selector="CONTR").all()
        Worker.objects.bulk_create([
            Worker(first_name='Alice', last_name='Smith', identificator='1234567890', brewery=breweries[0]),
            Worker(first_name='Bob', last_name='Johnson', identificator='0987654321', brewery=breweries[0]),
            Worker(first_name='Charlie', last_name='Brown', identificator='12781377231', brewery=breweries[1]),
            Worker(first_name='David', last_name='White', identificator='1261377231', brewery=breweries[1]),
            Worker(first_name='Eve', last_name='Black', identificator='1221471231', brewery=breweries[2]),
            Worker(first_name='Frank', last_name='Green', identificator='1214847231', brewery=breweries[2]),
        ])
        print('Workers created.')

    def create_sectors(self):
        if Sector.objects.exists():
            return
        breweries = Brewery.objects.all()
        Sector.objects.bulk_create([
            Sector(name='Sector 1.1', allows_bacteria=True, brewery=breweries[0]),
            Sector(name='Sector 1.2', allows_bacteria=True, brewery=breweries[0]),
            Sector(name='Sector 2.1', allows_bacteria=False, brewery=breweries[1]),
            Sector(name='Sector 2.2', allows_bacteria=False, brewery=breweries[1]),
            Sector(name='Sector 3.1', allows_bacteria=True, brewery=breweries[0]),
            Sector(name='Sector 3.2', allows_bacteria=False, brewery=breweries[0]),
        ])
        print('Sectors created.')

    def create_equipment(self):
        if Equipment.objects.exists():
            return

        breweries = Brewery.objects.all()
        sectors = Sector.objects.all()

        Equipment.objects.bulk_create([
            Equipment(selector='VAT', capacity=500, name='Vat 1.1', daily_price=150.00, min_temperature=15, max_temperature=40, brewery=breweries[0], sector=sectors[0]),
            Equipment(selector='VAT', capacity=300, name='Vat 1.2', daily_price=150.00, min_temperature=20, max_temperature=80, brewery=breweries[0], sector=sectors[0]),
            Equipment(selector='BREWSET', capacity=300, name='Brewset 1.1', daily_price=100.00, brewery=breweries[0], sector=sectors[1]),
            Equipment(selector='BREWSET', capacity=600, name='Brewset 1.2', daily_price=130.00, brewery=breweries[0], sector=sectors[1]),
            Equipment(selector='VAT', capacity=200, name='Vat 2.1', daily_price=170.00, min_temperature=25, max_temperature=60, brewery=breweries[1], sector=sectors[2]),
            Equipment(selector='VAT', capacity=400, name='Vat 2.2', daily_price=250.00, min_temperature=10, max_temperature=120, brewery=breweries[1], sector=sectors[2]),
            Equipment(selector='BREWSET', capacity=350, name='Brewset 2.1', daily_price=300.00, brewery=breweries[1], sector=sectors[3]),
            Equipment(selector='BREWSET', capacity=700, name='Brewset 2.2', daily_price=135.00, brewery=breweries[1], sector=sectors[3]),
            Equipment(selector='VAT', capacity=200, name='Vat 3.1', daily_price=120.00, min_temperature=30, max_temperature=70, brewery=breweries[2], sector=sectors[4]),
            Equipment(selector='VAT', capacity=400, name='Vat 3.2', daily_price=150.00, min_temperature=10, max_temperature=100, brewery=breweries[2], sector=sectors[5]),
            Equipment(selector='BREWSET', capacity=350, name='Brewset 3.1', daily_price=200.00, brewery=breweries[2], sector=sectors[5]),
            Equipment(selector='BREWSET', capacity=700, name='Brewset 3.2', daily_price=95.00, brewery=breweries[2], sector=sectors[5]),
        ])
        print('Equipment created.')

    def create_reservations(self):
        if Reservation.objects.exists():
            return

        breweries = Brewery.objects.all()
        workers = Worker.objects.all()
        Reservation.objects.bulk_create([
            Reservation(price=5000, brew_size=1000, production_brewery=breweries[0],
                        contract_brewery=breweries[3], allows_sector_share=True),
            Reservation(price=7000, brew_size=700, production_brewery=breweries[0],
                        contract_brewery=breweries[4], allows_sector_share=True),
            Reservation(price=5500, brew_size=500, production_brewery=breweries[1],
                        contract_brewery=breweries[3], allows_sector_share=True),
        ])
        reservations = Reservation.objects.all()
        reservations[0].authorised_workers.set([workers[0], workers[1]])
        reservations[1].authorised_workers.set([workers[2], workers[3]])
        reservations[2].authorised_workers.set([workers[4], workers[5]])
        print('Reservations created.')

    def create_equipment_reservations(self):
        if EquipmentReservation.objects.exists():
            return

        equipment = Equipment.objects.all()
        reservations = Reservation.objects.all()
        start_date = datetime(2025, 2, 1, 12, 0, 0).date()
        EquipmentReservation.objects.bulk_create([
            EquipmentReservation(selector=EquipmentReservation.EquipmentSelectors.BREW,
                                 start_date=start_date, end_date=start_date + timedelta(days=1),
                                 equipment=equipment[0],
                                 reservation_id=reservations[0]),
            EquipmentReservation(selector=EquipmentReservation.EquipmentSelectors.BREW,
                                 start_date=start_date, end_date=start_date + timedelta(days=1),
                                 equipment=equipment[2],
                                 reservation_id=reservations[0]),
            EquipmentReservation(selector=EquipmentReservation.EquipmentSelectors.BREW,
                                 start_date=start_date+timedelta(days=1), end_date=start_date + timedelta(days=4),
                                 equipment=equipment[1],
                                 reservation_id=reservations[1]),
            EquipmentReservation(selector=EquipmentReservation.EquipmentSelectors.BREW,
                                 start_date=start_date+timedelta(days=1), end_date=start_date + timedelta(days=4),
                                 equipment=equipment[3],
                                 reservation_id=reservations[1]),
            EquipmentReservation(selector=EquipmentReservation.EquipmentSelectors.BREW,
                                 start_date=start_date+timedelta(days=10), end_date=start_date + timedelta(days=13),
                                 equipment=equipment[4],
                                 reservation_id=reservations[2]),
            EquipmentReservation(selector=EquipmentReservation.EquipmentSelectors.BREW,
                                 start_date=start_date+timedelta(days=13), end_date=start_date + timedelta(days=15),
                                 equipment=equipment[6],
                                 reservation_id=reservations[2]),

        ])
        print('Equipment reservations created.')

    def create_recipes(self):
        if Recipe.objects.exists():
            return

        beer_types = BeerType.objects.all()
        breweries = Brewery.objects.all()
        Recipe.objects.bulk_create([
            Recipe(name='Recipe 1', mashing_body='Mashing body 1', lautering_body='Lautering body 1',
                   boiling_body='Boiling body 1', fermentation_body='Fermentation body 1',
                   lagerring_body='Lagerring body 1', beer_type=beer_types[0], contract_brewery=breweries[3]),
        ])
        print('Recipes created.')

    def create_execution_logs(self):
        if ExecutionLog.objects.exists():
            return

        recipes = Recipe.objects.all()
        reservations = Reservation.objects.all()
        ExecutionLog.objects.bulk_create([
            ExecutionLog(start_date=timezone.now().date(), end_date=timezone.now().date() + timedelta(days=2),
                         is_successful=True, recipe=recipes[0], reservation=reservations[0],
                         mashing_log='Mashing log', lautering_log='Lautering log',
                         boiling_log='Boiling log', fermentation_log='Fermentation log',
                         lagerring_log='Lagerring log'),
        ])
        print('Execution logs created.')

    def create_vat_packaging(self):
        if Vatpackaging.objects.exists():
            return

        equipment = Equipment.objects.filter(selector=Equipment.EquipmentSelectors.VAT).all()
        Vatpackaging.objects.bulk_create([
            Vatpackaging(equipment=equipment[0], packaging_type=Vatpackaging.PackagingTypes.BOTTLE),
            Vatpackaging(equipment=equipment[0], packaging_type=Vatpackaging.PackagingTypes.CAN),
            Vatpackaging(equipment=equipment[0], packaging_type=Vatpackaging.PackagingTypes.KEG),
            Vatpackaging(equipment=equipment[1], packaging_type=Vatpackaging.PackagingTypes.BOTTLE),
            Vatpackaging(equipment=equipment[1], packaging_type=Vatpackaging.PackagingTypes.CAN),
            Vatpackaging(equipment=equipment[1], packaging_type=Vatpackaging.PackagingTypes.KEG),
            Vatpackaging(equipment=equipment[2], packaging_type=Vatpackaging.PackagingTypes.BOTTLE),
            Vatpackaging(equipment=equipment[2], packaging_type=Vatpackaging.PackagingTypes.CAN),
            Vatpackaging(equipment=equipment[2], packaging_type=Vatpackaging.PackagingTypes.KEG),
            Vatpackaging(equipment=equipment[3], packaging_type=Vatpackaging.PackagingTypes.BOTTLE),
            Vatpackaging(equipment=equipment[3], packaging_type=Vatpackaging.PackagingTypes.CAN),
            Vatpackaging(equipment=equipment[3], packaging_type=Vatpackaging.PackagingTypes.KEG),
            Vatpackaging(equipment=equipment[4], packaging_type=Vatpackaging.PackagingTypes.BOTTLE),
            Vatpackaging(equipment=equipment[4], packaging_type=Vatpackaging.PackagingTypes.CAN),
            Vatpackaging(equipment=equipment[4], packaging_type=Vatpackaging.PackagingTypes.KEG),
            Vatpackaging(equipment=equipment[5], packaging_type=Vatpackaging.PackagingTypes.BOTTLE),
            Vatpackaging(equipment=equipment[5], packaging_type=Vatpackaging.PackagingTypes.CAN),
            Vatpackaging(equipment=equipment[5], packaging_type=Vatpackaging.PackagingTypes.KEG),
        ])
        print('Vat packaging created.')

