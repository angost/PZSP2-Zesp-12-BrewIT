from .models import Account, Brewery, Equipment, Sector, Vatpackaging
from rest_framework import serializers
from django.contrib.auth import get_user_model
from django.contrib.auth.models import Group
from django.db import transaction

class AccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = get_user_model()
        fields = ['id', 'email', 'password']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        print(validated_data)
        user = get_user_model().objects.create_user(email=validated_data['email'],
                                                    password=validated_data['password'])
        return user


class RegistrationDataSerializer(serializers.Serializer):
    email = serializers.EmailField(required=True)
    password = serializers.CharField(required=True)
    password2 = serializers.CharField(required=True)
    role = serializers.CharField(required=True)
    selector = serializers.CharField(required=True)
    name = serializers.CharField(required=True)
    nip = serializers.CharField(required=True)
    water_ph = serializers.DecimalField(decimal_places=1,
                                        max_digits=3,
                                        required=False)

    def validate_email(self, value):
        if get_user_model().objects.filter(email=value).exists():
            raise serializers.ValidationError("Email already exists")
        return value

    def validate_selector(self, value):
        if value not in [el for el in Brewery.BrewerySelectors.values]:
            raise serializers.ValidationError("Invalid selectror")
        return value

    def validate_role(self, value):
        if value not in [el for el in Account.AccountRoles.values]:
            raise serializers.ValidationError("Invalid role")
        elif value == Account.AccountRoles.ADMIN.value:
            raise serializers.ValidationError("Cannot create admin account")
        return value

    def validate(self, data):
        if data['password'] != data['password2']:
            raise serializers.ValidationError("Passwords do not match")
        elif data['role'] == Account.AccountRoles.PRODUCTION.value and not data['water_ph']:
            raise serializers.ValidationError("Production brewery must specify water_ph")
        elif data['role'] != data['selector']:
            raise serializers.ValidationError("Role and selector must be the same")
        return data

    def create(self, validated_data):
        try:
            with transaction.atomic():
                account = get_user_model().objects.create_user(email=validated_data['email'],
                                            password=validated_data['password'],
                                            role=validated_data['role'])
                brewery = Brewery.objects.create(selector=validated_data['selector'],
                                                 name=validated_data['name'],
                                                 nip=validated_data['nip'],
                                                 water_ph=validated_data['water_ph'],
                                                 account=account)
                return (account, brewery)
        except Exception as e:
            raise serializers.ValidationError(str(e)) # Change later


class SectorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Sector
        fields = ['sector_id', 'name', 'allows_bacteria', 'brewery']
        extra_kwargs = {'brewery': {'read_only': True}}


class EquipmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Equipment
        fields = '__all__'
        extra_kwargs = {'brewery': {'read_only': True}}

    def validate(self, attrs):
        brewery = self.context['request'].user.get_brewery()
        sector = Sector.objects.get(sector_id=attrs['sector'].sector_id)
        if sector.brewery != brewery:
            raise serializers.ValidationError("You cannot add equipment to a sector from another brewery")
        return attrs


class BrewerySerializer(serializers.ModelSerializer):
    class Meta:
        model = Brewery
        fields = '__all__'
        extra_kwargs = {'account': {'read_only': True}}


class EquipmentFilterParametersSerializer(serializers.Serializer):
    start_date = serializers.DateTimeField(required=True)
    end_date = serializers.DateTimeField(required=True)
    capacity = serializers.IntegerField(required=True)
    min_temperature = serializers.DecimalField(decimal_places=2, max_digits=5, required=False)
    max_temperature = serializers.DecimalField(decimal_places=2, max_digits=5, required=False)
    production_brewery = serializers.IntegerField(required=True)
    uses_bacteria = serializers.BooleanField(required=True)
    selector = serializers.CharField(required=True)
    allows_sector_share = serializers.BooleanField(required=True)
    package_type = serializers.CharField(required=False)

    def validate_production_brewery(self, value):
        try:
            brewery = Brewery.objects.get(value)
            if brewery.selector != Brewery.BrewerySelectors.PRODUCTION.value:
                raise serializers.ValidationError("Production brewery does not exist")
            return value
        except:
            raise serializers.ValidationError("Brewery does not exist")

    def validate_selector(self, value):
        if value not in [el for el in Equipment.EquipmentSelectors.values]:
            raise serializers.ValidationError("Invalid selector")
        return value

    def validate(self, attrs):
        if attrs['selector'] == Equipment.EquipmentSelectors.VAT.value:
            if attrs.get('package_type') is None:
                raise serializers.ValidationError("Package type is required for vat")
            if attrs.get('package_type') not in [el for el in Vatpackaging.PackagingTypes.values]:
                raise serializers.ValidationError("Wrong package type")
            if attrs.get('min_temperature') is None or attrs.get('max_temperature') is None:
                raise serializers.ValidationError("Min and max temperature are required for vat")
        return attrs


class BreweriesFilterParametersSerializer(serializers.Serializer):
    vat_start_date = serializers.DateTimeField(required=True)
    vat_end_date = serializers.DateTimeField(required=True)
    vat_capacity = serializers.IntegerField(required=True)
    vat_min_temperature = serializers.DecimalField(decimal_places=2, max_digits=5, required=True)
    vat_max_temperature = serializers.DecimalField(decimal_places=2, max_digits=5, required=True)
    vat_package_type = serializers.CharField(required=True)
    brewset_start_date = serializers.DateTimeField(required=True)
    brewset_end_date = serializers.DateTimeField(required=True)
    brewset_capacity = serializers.IntegerField(required=True)
    uses_bacteria = serializers.BooleanField(required=True)
    allows_sector_share = serializers.BooleanField(required=True)
    water_ph_min = serializers.DecimalField(decimal_places=1, max_digits=3, required=True)
    water_ph_max = serializers.DecimalField(decimal_places=1, max_digits=3, required=True)

    def validate_vat_package_type(self, value):
        if value not in [el for el in Vatpackaging.PackagingTypes.values]:
            raise serializers.ValidationError("Invalid package type")
        return value
