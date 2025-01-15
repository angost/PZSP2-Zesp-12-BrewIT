from rest_framework.test import APITestCase, APIClient
from rest_framework import status
from ..models import (
    Account, Brewery, Sector, Equipment
)
from ..serializers import (
    SectorSerializer
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


@override_settings(SECURE_SSL_REDIRECT=False)
class SectorListTests(APITestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = Account.objects.create_user(
            email='testuser@example.com',
            password='testpass',
            role=Account.AccountRoles.PRODUCTION
        )
        self.brewery = Brewery.objects.create(
            selector=Brewery.BrewerySelectors.PRODUCTION,
            name="Test Brewery",
            account=self.user
        )
        self.sector1 = Sector.objects.create(
            name="Sector 1",
            allows_bacteria=False,
            brewery=self.brewery
        )
        self.sector2 = Sector.objects.create(
            name="Sector 2",
            allows_bacteria=True,
            brewery=self.brewery
        )
        self.client.login(email="testuser@example.com", password="testpass")

        self.sectors_url = '/api/sectors/'

    def test_get_sector_list(self):
        response = self.client.get(self.sectors_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        sectors = Sector.objects.filter(brewery=self.brewery)
        serializer = SectorSerializer(sectors, many=True, context={'request': response.wsgi_request})
        self.assertEqual(response.data, serializer.data)

    def test_post_sector(self):
        data = {
            "name": "New Sector"
        }
        response = self.client.post(self.sectors_url, data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        self.assertTrue(Sector.objects.filter(name="New Sector", brewery=self.brewery).exists())

    def test_post_sector_invalid_data(self):
        data = {"invalid_field": "value"}
        response = self.client.post(self.sectors_url, data)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

@override_settings(SECURE_SSL_REDIRECT=False)
class SectorDetailListTests(APITestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = Account.objects.create_user(
            email='testuser@example.com',
            password='testpass',
            role=Account.AccountRoles.PRODUCTION
        )
        self.brewery = Brewery.objects.create(
            selector=Brewery.BrewerySelectors.PRODUCTION,
            name="Test Brewery",
            account=self.user
        )
        self.sector1 = Sector.objects.create(
            name="Sector 1",
            allows_bacteria=False,
            brewery=self.brewery
        )
        self.client.login(email="testuser@example.com", password="testpass")

        self.sectors_url = '/api/sectors/'

    def test_get_sector_detail(self):
        response = self.client.get(f'{self.sectors_url}{self.sector1.pk}/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        serializer = SectorSerializer(self.sector1, context={'request': response.wsgi_request})
        self.assertEqual(response.data, serializer.data)

    def test_put_sector(self):
        data = {
            "name": "Updated Sector Name"
        }
        response = self.client.put(f'{self.sectors_url}{self.sector1.pk}/', data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        self.sector1.refresh_from_db()
        self.assertEqual(self.sector1.name, "Updated Sector Name")

    def test_put_sector_invalid_data(self):
        data = {"name": ""}  # Empty name is invalid
        response = self.client.put(f'{self.sectors_url}{self.sector1.pk}/', data)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_delete_sector(self):
        response = self.client.delete(f'{self.sectors_url}{self.sector1.pk}/')
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertFalse(Sector.objects.filter(pk=self.sector1.pk).exists())


@override_settings(SECURE_SSL_REDIRECT=False)
class BaseTestSetup(APITestCase):

    @classmethod
    def setUpTestData(cls):
        cls.client = APIClient()

        cls.contract_user = Account.objects.create_user(
            email='contruser@example.com',
            password='testpass',
            role=Account.AccountRoles.CONTRACT
        )
        cls.production_user = Account.objects.create_user(
            email='produser@example.com',
            password='testpass',
            role=Account.AccountRoles.PRODUCTION
        )
        cls.brewery = Brewery.objects.create(
            selector=Brewery.BrewerySelectors.PRODUCTION,
            name='Test Brewery',
            account=cls.production_user
        )
        cls.sector = Sector.objects.create(
            name='Sector 1',
            allows_bacteria=False,
            brewery=cls.brewery
        )
        cls.equipment1 = Equipment.objects.create(
            selector=Equipment.EquipmentSelectors.VAT,
            capacity=100,
            name='Vat #1',
            daily_price=50.00,
            min_temperature=15,
            max_temperature=35,
            brewery=cls.brewery,
            sector=cls.sector
        )
        cls.equipment2 = Equipment.objects.create(
            selector=Equipment.EquipmentSelectors.BREWSET,
            capacity=200,
            name='Brewset #2',
            daily_price=100.00,
            brewery=cls.brewery,
            sector=cls.sector
        )

@override_settings(SECURE_SSL_REDIRECT=False)
class EquipmentListTests(APITestCase):
    def setUp(self):
        self.client = APIClient()

        self.contract_user = Account.objects.create_user(
            email='contruser@example.com',
            password='testpass',
            role=Account.AccountRoles.CONTRACT
        )
        self.production_user = Account.objects.create_user(
            email='produser@example.com',
            password='testpass',
            role=Account.AccountRoles.PRODUCTION
        )
        self.brewery = Brewery.objects.create(
            selector=Brewery.BrewerySelectors.PRODUCTION,
            name='Test Brewery',
            account=self.production_user
        )
        self.sector = Sector.objects.create(
            name='Sector 1',
            allows_bacteria=False,
            brewery=self.brewery
        )
        self.equipment1 = Equipment.objects.create(
            selector=Equipment.EquipmentSelectors.VAT,
            capacity=100,
            name='Vat #1',
            daily_price=50.00,
            min_temperature=15,
            max_temperature=35,
            brewery=self.brewery,
            sector=self.sector
        )
        self.equipment2 = Equipment.objects.create(
            selector=Equipment.EquipmentSelectors.BREWSET,
            capacity=200,
            name='Brewset #2',
            daily_price=100.00,
            brewery=self.brewery,
            sector=self.sector
        )

    def test_get_equipment_list(self):
        self.client.force_authenticate(user=self.production_user)
        response = self.client.get('/api/equipment/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 2)
        self.assertEqual(response.data[0]['name'], 'Vat #1')
        self.assertEqual(response.data[1]['name'], 'Brewset #2')

    def test_post_equipment_as_contract_user(self):
        data = {'name': 'New Equipment'}
        self.client.force_authenticate(user=self.contract_user)
        response = self.client.post('/api/equipment/', data)

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_post_equipment_as_production_user(self):
        data = {
            'selector': 'VAT',
            'capacity': 120,
            'name' : 'vat',
            'daily_price' : 100,
            'min_temperature' : 10,
            'max_temperature' : 40,
            'brewery': self.brewery.brewery_id,
            'sector': self.sector.sector_id
        }
        self.client.force_authenticate(user=self.production_user)
        response = self.client.post('/api/equipment/', data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Equipment.objects.count(), 3)
        self.assertEqual(Equipment.objects.all()[2].name, 'vat')

@override_settings(SECURE_SSL_REDIRECT=False)
class EquipmentDetailTests(APITestCase):
    def setUp(self):
        self.client = APIClient()

        self.contract_user = Account.objects.create_user(
            email='contruser@example.com',
            password='testpass',
            role=Account.AccountRoles.CONTRACT
        )
        self.production_user = Account.objects.create_user(
            email='produser@example.com',
            password='testpass',
            role=Account.AccountRoles.PRODUCTION
        )
        self.brewery = Brewery.objects.create(
            selector=Brewery.BrewerySelectors.PRODUCTION,
            name='Test Brewery',
            account=self.production_user
        )
        self.sector = Sector.objects.create(
            name='Sector 1',
            allows_bacteria=False,
            brewery=self.brewery
        )
        self.equipment1 = Equipment.objects.create(
            selector=Equipment.EquipmentSelectors.VAT,
            capacity=100,
            name='Vat #1',
            daily_price=50.00,
            min_temperature=15,
            max_temperature=35,
            brewery=self.brewery,
            sector=self.sector
        )
        self.equipment2 = Equipment.objects.create(
            selector=Equipment.EquipmentSelectors.BREWSET,
            capacity=200,
            name='Brewset #2',
            daily_price=100.00,
            brewery=self.brewery,
            sector=self.sector
        )

    def test_get_equipment_detail(self):
        self.client.force_authenticate(user=self.production_user)
        response = self.client.get('/api/equipment/1/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['name'], self.equipment1.name)

    def test_put_valid_equipment(self):
        data = {
            'name': 'Updated Equipment',
            'daily_price': 20,
        }
        self.client.force_authenticate(user=self.production_user)
        response = self.client.put(f'/api/equipment/{self.equipment1.equipment_id}/', data)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.equipment1.refresh_from_db()
        self.assertEqual(self.equipment1.name, 'Updated Equipment')
        self.assertEqual(self.equipment1.daily_price, 20)

    def test_put_invalid_equipment(self):
        data = {'name': ''}
        self.client.force_authenticate(user=self.production_user)
        response = self.client.put(f'/api/equipment/{self.equipment1.equipment_id}/', data)

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('name', response.data)

