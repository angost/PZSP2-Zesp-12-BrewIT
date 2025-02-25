import datetime
from django.test import TestCase

# Create your tests here.
from django.test import TestCase
from django.core.exceptions import ValidationError
from django.utils import timezone
from ..models import (
    Account, BeerType, Brewery, Sector, Equipment, Recipe,
    ReservationRequest, EqipmentReservationRequest, Reservation,
    EquipmentReservation, ExecutionLog, Vatpackaging
)


class AccountModelTests(TestCase):

    def setUp(self):
        self.production_account = Account.objects.create_user(
            email="prod@example.com",
            password="securepassword",
            role=Account.AccountRoles.PRODUCTION
        )

        self.contract_account = Account.objects.create_user(
            email="contract@example.com",
            password="securepassword",
            role=Account.AccountRoles.CONTRACT
        )

        self.admin_account = Account.objects.create_superuser(
            email="admin@example.com",
            password="securepassword",
            role=Account.AccountRoles.ADMIN
        )

    def test_account_str(self):
        """Test the __str__ method returns the email."""
        self.assertEqual(str(self.production_account), "prod@example.com")
        self.assertEqual(str(self.contract_account), "contract@example.com")
        self.assertEqual(str(self.admin_account), "admin@example.com")

    def test_account_email_unique(self):
        """Ensure the email field is unique."""
        with self.assertRaises(ValidationError):
            duplicate_account = Account(
                email="prod@example.com",
                role=Account.AccountRoles.CONTRACT
            )
            duplicate_account.full_clean()

    def test_account_role_choices(self):
        """Test that only valid roles can be assigned."""
        with self.assertRaises(ValidationError):
            invalid_account = Account(
                email="invalid@example.com",
                role="INVALID"
            )
            invalid_account.full_clean()

    def test_get_brewery_none(self):
        """Test the get_brewery method behavior."""
        # Setup for this test would require a related Brewery model
        self.assertIsNone(self.production_account.get_brewery())

    def test_get_brewery_existing(self):
        brewery = Brewery.objects.create(
            selector=Brewery.BrewerySelectors.PRODUCTION,
            name="MyBrewery",
            account=self.production_account
        )
        self.assertEqual(brewery, self.production_account.get_brewery())

    def test_user_manager_creates_user(self):
        """Test the custom user manager can create a user."""
        user1 = self.production_account
        user2 = self.contract_account
        self.assertIsInstance(user1, Account)
        self.assertFalse(user1.is_staff)
        self.assertFalse(user1.is_superuser)
        self.assertIsInstance(user2, Account)
        self.assertFalse(user2.is_staff)
        self.assertFalse(user2.is_superuser)

    def test_user_manager_creates_superuser(self):
        """Test the custom user manager can create a superuser."""
        superuser = self.admin_account
        self.assertIsInstance(superuser, Account)
        self.assertTrue(superuser.is_staff)
        self.assertTrue(superuser.is_superuser)

    def test_email_normalization(self):
        """Test that emails are normalized during creation."""
        user = Account.objects.create_user(
            email=" testTEST@EXample.COM ",
            password="password123",
            role=Account.AccountRoles.PRODUCTION
        )
        self.assertEqual(user.email, "testTEST@example.com")

# TODO: add test: cannot create superuser with role prod, contr
# TODO: add test: cannot create user with role admin


class BeerTypeModelTests(TestCase):

    def setUp(self):
        self.lager = BeerType.objects.create(
            name="Lager",
            uses_bacteria=False
        )

    def test_beer_type_creation(self):
        self.assertEqual(self.lager.name, "Lager")
        self.assertFalse(self.lager.uses_bacteria)

    def test_beer_type_name_unique(self):
        """Ensure the name field is unique."""
        with self.assertRaises(ValidationError):
            duplicate_beer_type = BeerType(
                name="Lager",
                uses_bacteria=True
            )
            duplicate_beer_type.full_clean()

class BreweryModelTests(TestCase):

    def setUp(self):
        self.user = Account.objects.create_user(
            email="user@example.com",
            password="password",
            role=Account.AccountRoles.PRODUCTION
        )

    def test_create_brewery(self):
        brewery = Brewery.objects.create(
            selector=Brewery.BrewerySelectors.PRODUCTION,
            name="Great Brewery",
            nip="1234567890",
            water_ph=7.0,
            account=self.user
        )
        self.assertEqual(brewery.name, "Great Brewery")
        self.assertEqual(brewery.selector, Brewery.BrewerySelectors.PRODUCTION)
        self.assertEqual(brewery.nip, "1234567890")
        self.assertEqual(float(brewery.water_ph), 7.0)
        self.assertEqual(brewery.account, self.user)

    def test_selector_choices_validation(self):
        with self.assertRaises(ValidationError):
            brewery = Brewery.objects.create(
                selector="INVALID",
                name="Invalid Brewery",
                account=self.user
            )
            brewery.full_clean()


class SectorModelTests(TestCase):

    def test_create_sector(self):
        account = Account.objects.create_user(
            email='sector@example.com',
            password='testpassword123',
            role=Account.AccountRoles.PRODUCTION
        )
        brewery = Brewery.objects.create(
            selector=Brewery.BrewerySelectors.PRODUCTION,
            name='Brewery For Sector',
            account=account
        )
        sector = Sector.objects.create(
            name='Fermentation',
            allows_bacteria=True,
            brewery=brewery
        )
        self.assertEqual(sector.name, 'Fermentation')
        self.assertTrue(sector.allows_bacteria)
        self.assertEqual(sector.brewery, brewery)


class EquipmentModelTests(TestCase):

    def test_create_equipment(self):
        account = Account.objects.create_user(
            email='equipment@example.com',
            password='testpassword123',
            role=Account.AccountRoles.PRODUCTION
        )
        brewery = Brewery.objects.create(
            selector=Brewery.BrewerySelectors.PRODUCTION,
            name='Equipment Brewery',
            account=account
        )
        sector = Sector.objects.create(
            name='Sector 1',
            allows_bacteria=False,
            brewery=brewery
        )
        equipment = Equipment.objects.create(
            selector=Equipment.EquipmentSelectors.VAT,
            capacity=100,
            name='Vat #1',
            daily_price=50.00,
            min_temperature=15,
            max_temperature=35,
            brewery=brewery,
            sector=sector
        )
        self.assertEqual(equipment.selector, Equipment.EquipmentSelectors.VAT)
        self.assertEqual(equipment.capacity, 100)
        self.assertEqual(equipment.min_temperature, 15)
        self.assertEqual(equipment.max_temperature, 35)
        self.assertEqual(equipment.brewery, brewery)
        self.assertEqual(equipment.sector, sector)


class RecipeModelTests(TestCase):

    def test_create_recipe(self):
        beer_type = BeerType.objects.create(name='Lager', uses_bacteria=False)
        account = Account.objects.create_user(
            email='recipe@example.com',
            password='testpassword123',
            role=Account.AccountRoles.CONTRACT
        )
        brewery = Brewery.objects.create(
            selector=Brewery.BrewerySelectors.CONTRACT,
            name='Brewery for Recipes',
            account=account
        )
        recipe = Recipe.objects.create(
            recipe_body='Ingredients list ...',
            beer_type=beer_type,
            contract_brewery=brewery
        )
        self.assertIsNotNone(recipe.recipe_id)
        self.assertEqual(recipe.beer_type, beer_type)
        self.assertEqual(recipe.contract_brewery, brewery)


class ReservationRequestModelTests(TestCase):
    def test_create_reservation_request(self):
        """
        Ensure we can create a ReservationRequest.
        """
        account_prod = Account.objects.create_user(
            email='prod@example.com',
            password='testpassword123',
            role=Account.AccountRoles.PRODUCTION
        )
        account_contr = Account.objects.create_user(
            email='contr@example.com',
            password='testpassword123',
            role=Account.AccountRoles.CONTRACT
        )
        brewery_prod = Brewery.objects.create(
            selector=Brewery.BrewerySelectors.PRODUCTION,
            name='Production Brewery RQ',
            account=account_prod
        )
        brewery_contr = Brewery.objects.create(
            selector=Brewery.BrewerySelectors.CONTRACT,
            name='Contract Brewery RQ',
            account=account_contr
        )
        rr = ReservationRequest.objects.create(
            price=1000,
            brew_size=500,
            authorised_workers='John Doe, Alice Brown',
            production_brewery=brewery_prod,
            contract_brewery=brewery_contr,
            allows_sector_share=True
        )
        self.assertEqual(rr.price, 1000)
        self.assertEqual(rr.brew_size, 500)
        self.assertIn('John', rr.authorised_workers)
        self.assertEqual(rr.production_brewery, brewery_prod)
        self.assertEqual(rr.contract_brewery, brewery_contr)
        self.assertTrue(rr.allows_sector_share)


class EqipmentReservationRequestModelTests(TestCase):

    def test_create_equipment_reservation_request(self):
        account = Account.objects.create_user(
            email='eq_res_req@example.com',
            password='testpassword123',
            role=Account.AccountRoles.PRODUCTION
        )
        brewery = Brewery.objects.create(
            selector=Brewery.BrewerySelectors.PRODUCTION,
            name='Equipment Reservations Brewery',
            account=account
        )
        sector = Sector.objects.create(
            name='Sector #2',
            allows_bacteria=False,
            brewery=brewery
        )
        equipment = Equipment.objects.create(
            selector=Equipment.EquipmentSelectors.BREWSET,
            capacity=200,
            name='Brewset #2',
            daily_price=100.00,
            brewery=brewery,
            sector=sector
        )
        rr = ReservationRequest.objects.create(
            price=2000,
            brew_size=1000,
            production_brewery=brewery,
            contract_brewery=brewery,
            allows_sector_share=False
        )
        now = timezone.now()
        later = now + datetime.timedelta(days=1)

        eq_res_req = EqipmentReservationRequest.objects.create(
            start_date=now,
            end_date=later,
            equipment=equipment,
            reservation_request=rr
        )
        self.assertEqual(eq_res_req.equipment, equipment)
        self.assertEqual(eq_res_req.reservation_request, rr)
        self.assertEqual(eq_res_req.start_date, now)
        self.assertEqual(eq_res_req.end_date, later)


class ReservationModelTests(TestCase):
    def test_create_reservation(self):

        account_prod = Account.objects.create_user(
            email='res_prod@example.com',
            password='testpassword123',
            role=Account.AccountRoles.PRODUCTION
        )
        account_contr = Account.objects.create_user(
            email='res_contr@example.com',
            password='testpassword123',
            role=Account.AccountRoles.CONTRACT
        )
        brewery_prod = Brewery.objects.create(
            selector=Brewery.BrewerySelectors.PRODUCTION,
            name='Production Brewery RS',
            account=account_prod
        )
        brewery_contr = Brewery.objects.create(
            selector=Brewery.BrewerySelectors.CONTRACT,
            name='Contract Brewery RS',
            account=account_contr
        )
        reservation = Reservation.objects.create(
            price=5000,
            brew_size=2000,
            authorised_workers='John Doe, Bob Brown',
            production_brewery=brewery_prod,
            contract_brewery=brewery_contr,
            allows_sector_share=True
        )
        self.assertEqual(reservation.price, 5000)
        self.assertEqual(reservation.brew_size, 2000)
        self.assertIn('John Doe', reservation.authorised_workers)
        self.assertEqual(reservation.production_brewery, brewery_prod)
        self.assertEqual(reservation.contract_brewery, brewery_contr)
        self.assertTrue(reservation.allows_sector_share)


class EquipmentReservationModelTests(TestCase):
    def test_create_equipment_reservation(self):

        account = Account.objects.create_user(
            email='eq_res@example.com',
            password='testpassword123',
            role=Account.AccountRoles.PRODUCTION
        )
        brewery = Brewery.objects.create(
            selector=Brewery.BrewerySelectors.PRODUCTION,
            name='Equipment Reservation Brewery',
            account=account
        )
        sector = Sector.objects.create(
            name='Sector #3',
            allows_bacteria=False,
            brewery=brewery
        )
        equipment = Equipment.objects.create(
            selector=Equipment.EquipmentSelectors.BREWSET,
            capacity=300,
            name='Brewset #3',
            daily_price=80.00,
            brewery=brewery,
            sector=sector
        )
        reservation = Reservation.objects.create(
            price=3000,
            brew_size=1500,
            production_brewery=brewery,
            contract_brewery=brewery,
            allows_sector_share=False
        )
        now = timezone.now()
        later = now + datetime.timedelta(days=3)

        eq_res = EquipmentReservation.objects.create(
            selector=EquipmentReservation.EquipmentSelectors.BREW,
            start_date=now,
            end_date=later,
            equipment=equipment,
            reservation_id=reservation
        )
        self.assertEqual(eq_res.selector, EquipmentReservation.EquipmentSelectors.BREW)
        self.assertEqual(eq_res.start_date, now)
        self.assertEqual(eq_res.end_date, later)
        self.assertEqual(eq_res.equipment, equipment)
        self.assertEqual(eq_res.reservation_id, reservation)


class ExecutionLogModelTests(TestCase):
    def test_create_execution_log(self):

        beer_type = BeerType.objects.create(name='Stout', uses_bacteria=False)
        account = Account.objects.create_user(
            email='exec_log@example.com',
            password='testpassword123',
            role=Account.AccountRoles.CONTRACT
        )
        brewery = Brewery.objects.create(
            selector=Brewery.BrewerySelectors.CONTRACT,
            name='ExecutionLog Brewery',
            account=account
        )
        recipe = Recipe.objects.create(
            recipe_body='Some recipe text...',
            beer_type=beer_type,
            contract_brewery=brewery
        )
        reservation = Reservation.objects.create(
            price=10000,
            brew_size=5000,
            production_brewery=brewery,
            contract_brewery=brewery,
            allows_sector_share=False
        )

        now = timezone.now()
        log = ExecutionLog.objects.create(
            start_date=now,
            is_successful=False,
            log='Starting brew process',
            recipe=recipe,
            reservation=reservation
        )
        self.assertIsNotNone(log.log_id)
        self.assertEqual(log.start_date, now)
        self.assertFalse(log.is_successful)
        self.assertIn('Starting brew process', log.log)


class VatpackagingModelTests(TestCase):

    def test_create_vatpackaging(self):
        account = Account.objects.create_user(
            email='vatpackaging@example.com',
            password='testpassword123',
            role=Account.AccountRoles.PRODUCTION
        )
        brewery = Brewery.objects.create(
            selector=Brewery.BrewerySelectors.PRODUCTION,
            name='Packaging Brewery',
            account=account
        )
        sector = Sector.objects.create(
            name='Packaging Sector',
            allows_bacteria=False,
            brewery=brewery
        )
        equipment = Equipment.objects.create(
            selector=Equipment.EquipmentSelectors.VAT,
            capacity=400,
            name='Vat #4',
            daily_price=100.00,
            brewery=brewery,
            sector=sector
        )
        vatpackaging = Vatpackaging.objects.create(
            equipment=equipment,
            packaging_type=Vatpackaging.PackagingTypes.BOTTLE
        )
        self.assertIsNotNone(vatpackaging.vat_packaging_id)
        self.assertEqual(vatpackaging.equipment, equipment)
        self.assertEqual(vatpackaging.packaging_type, Vatpackaging.PackagingTypes.BOTTLE)
