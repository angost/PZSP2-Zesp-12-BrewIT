from .models import Account, Brewery, Equipment, Sector
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
        fields = ['sector_id', 'name', 'allows_bacteria']


class EquipmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Equipment
        fields = '__all__'
        extra_kwargs = {'brewery': {'read_only': True}}

    def create(self, validated_data):
        validated_data['brewery'] = self.context['brewery']
        return super().create(validated_data)





