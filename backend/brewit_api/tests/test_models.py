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

    def test_get_brewery(self):
        """Test the get_brewery method behavior."""
        # Setup for this test would require a related Brewery model
        self.assertIsNone(self.production_account.get_brewery())

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
