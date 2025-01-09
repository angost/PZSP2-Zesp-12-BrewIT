from django.test import TestCase

# Create your tests here.
from django.test import TestCase
from django.core.exceptions import ValidationError
from django.utils.timezone import now
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