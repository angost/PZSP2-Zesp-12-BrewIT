from rest_framework.test import APITestCase, APIClient
from rest_framework import status
from ..models import (
    Account
)
from django.test import override_settings

@override_settings(SECURE_SSL_REDIRECT=False)
class AccountAPITest(APITestCase):
    def setUp(self):
        self.client = APIClient()

        # Create a test user
        self.user1 = Account.objects.create_user(
            email="testuser@example.com",
            password="password123",
            role=Account.AccountRoles.PRODUCTION
        )
        self.user2 = Account.objects.create_user(
            email="testuser2@example.com",
            password="password234",
            role=Account.AccountRoles.CONTRACT
        )

        # Authenticate the client
        # Login testuser
        self.client.login(email="testuser@example.com", password="password123")

        # Set up URLs
        self.login_url = '/api/login/'
        self.logout_url = '/api/logout/'
        self.account_list_url = '/api/users/'

    def test_login_success(self):
        """Test a successful login"""
        response = self.client.post(self.login_url, {
            'email': 'testuser@example.com',
            'password': 'password123',
        })
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('Logged in successfully.', response.data['detail'])

    def test_login_failure(self):
        """Test a failed login with incorrect credentials"""
        response = self.client.post(self.login_url, {
            'email': 'testuser@example.com',
            'password': 'wrongpassword',
        })
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('Email or Password is incorrect.', response.data['detail'])

    def test_logout(self):
        # Logout testuser
        response = self.client.post(self.logout_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('Logged out successfully.', response.data['detail'])

    def test_account_list(self):
        # Test endpoint for listing all users
        response = self.client.get(self.account_list_url)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)  # Verify two users exist
        emails = [user['email'] for user in response.data]
        self.assertIn(self.user1.email, emails)
        self.assertIn(self.user2.email, emails)

    def test_account_list_empty(self):
        # Clear all users and test
        Account.objects.all().delete()
        response = self.client.get(self.account_list_url)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 0)

    def test_account_detail_returns_correct_user(self):
        # Test endpoint for retrieving a specific user
        response = self.client.get(f"{self.account_list_url}{self.user1.pk}/")

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['email'], self.user1.email)

    def test_account_detail_user_not_found(self):
        # Test for a non-existent user
        response = self.client.get(f"{self.account_list_url}9999/")  # ID that does not exist

        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
