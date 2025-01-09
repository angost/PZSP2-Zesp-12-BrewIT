from django.core.management.base import BaseCommand


from brewit_api.models import (
    Account, BeerType, Brewery, Sector, Equipment,
    EquipmentReservation, Recipe, Reservation, ExecutionLog, Vatpackaging
)

class Command(BaseCommand):
    help = "Populates the database with needed initial data."

    def handle(self, *args, **kwargs):
        self.create_beer_types()
        self.stdout.write(self.style.SUCCESS('Initial data successfully created!'))

    def create_beer_types(self):
        if BeerType.objects.exists():
            print('Beer types already exist. Aborting.')
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

