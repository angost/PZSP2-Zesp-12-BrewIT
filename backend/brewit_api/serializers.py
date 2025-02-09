from .models import Account, Brewery, Equipment, Sector, Vatpackaging,\
                    EqipmentReservationRequest, ReservationRequest, EquipmentReservation,\
                    Reservation, Recipe, ExecutionLog, BeerType, RegistrationRequest
from rest_framework import serializers
from django.contrib.auth import get_user_model
from django.contrib.auth.models import Group
from django.db import transaction
from django.db.models import Q
from datetime import timedelta
import math
from django.contrib.auth.hashers import make_password
from django.contrib.auth.password_validation import validate_password


class AccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = get_user_model()
        fields = ['id', 'email', 'role']


class RegistrationRequestSerializer(serializers.ModelSerializer):
    password2 = serializers.CharField(write_only=True, required=True)
    class Meta:
        model = RegistrationRequest
        fields = '__all__'
        extra_kwargs = {'password': {'write_only': True},
                        'role': {'read_only': True},}


    def validate_email(self, value):
        if get_user_model().objects.filter(email=value).exists():
            raise serializers.ValidationError("Account with this email already exists")
        return value

    def validate_password(self, value):
        try:
            validate_password(value)
        except Exception as e:
            raise serializers.ValidationError(str(e))
        return value

    def validate_selector(self, value):
        if value not in [el for el in Brewery.BrewerySelectors.values]:
            raise serializers.ValidationError("Invalid selector")
        return value

    def validate(self, attrs):
        print(attrs)

        if attrs['password'] != attrs['password2']:
            raise serializers.ValidationError("Passwords do not match")
        elif attrs['selector'] == Brewery.BrewerySelectors.PRODUCTION.value and not attrs['water_ph']:
            raise serializers.ValidationError("Production brewery must specify water_ph")
        elif attrs['selector'] == Brewery.BrewerySelectors.PRODUCTION.value and not attrs['nip']:
            raise serializers.ValidationError("Production brewery must specify nip")
        return attrs

    def create(self, validated_data):
        password = make_password(validated_data['password'])
        return RegistrationRequest.objects.create(email=validated_data['email'],
                                                  password=password,
                                                  role=validated_data['selector'],
                                                  selector=validated_data['selector'],
                                                  name=validated_data['name'],
                                                  nip=validated_data['nip'],
                                                  water_ph=validated_data.get('water_ph'))


class BreweryCreateSerializer(serializers.Serializer):
    registration_request_id = serializers.IntegerField(required=True)

    def validate(self, attrs):
        try:
            registration_request = RegistrationRequest.objects.get(id=attrs['registration_request_id'])
        except RegistrationRequest.DoesNotExist:
            raise serializers.ValidationError("Registration request does not exist")
        email = registration_request.email
        if get_user_model().objects.filter(email=email).exists():
            raise serializers.ValidationError("Account with this email already exists")
        return attrs

    def create(self, validated_data):
        try:
            with transaction.atomic():
                registration_request = RegistrationRequest.objects.get(id=validated_data['registration_request_id'])
                account = get_user_model().objects.create(email=registration_request.email,
                                                          password=registration_request.password,
                                                          role=registration_request.role)

                brewery = Brewery.objects.create(selector=registration_request.selector,
                                                 name=registration_request.name,
                                                 nip=registration_request.nip,
                                                 water_ph=registration_request.water_ph,
                                                 account=account)
                registration_request.delete()
                return brewery
        except Exception as e:
            raise serializers.ValidationError(str(e))


class BreweryWithAccountSerializer(serializers.ModelSerializer):
    account = AccountSerializer()
    class Meta:
        model = Brewery
        fields = '__all__'


class SectorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Sector
        fields = ['sector_id', 'name', 'allows_bacteria', 'brewery']
        extra_kwargs = {'brewery': {'read_only': True}}

class SectorEditSerializer(serializers.ModelSerializer):
    class Meta:
        model = Sector
        fields = ['name']


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

class EquipmentEditSerializer(serializers.ModelSerializer):
    class Meta:
        model = Equipment
        fields = ['name', 'daily_price', 'description']


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
            brewery = Brewery.objects.get(brewery_id=value)
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


class EqipmentReservationRequestSerializer(serializers.ModelSerializer):
    class Meta:
        model = EqipmentReservationRequest
        fields = ['start_date', 'end_date', 'equipment']

    def validate(self, attrs):
        if EquipmentReservation.objects.filter(
                equipment=attrs['equipment'],
                start_date__lt=attrs['end_date'],
                end_date__gt=attrs['start_date']
            ).exists():
            raise serializers.ValidationError("Equipment is already reserved for that period")

        return attrs


class ReservationRequestSerializer(serializers.ModelSerializer):
    equipment_reservation_requests = EqipmentReservationRequestSerializer(many=True)

    class Meta:
        model = ReservationRequest
        fields = '__all__'

        extra_kwargs = {'price': {'read_only': True},
                        'contract_brewery': {'read_only': True},
                        'id': {'read_only': True}
             }

    def validate(self, attrs):
        reservations_data = attrs.get('equipment_reservation_requests')
        allows_sector_share = attrs.get('allows_sector_share')
        contract = self.context.get('contract_brewery')

        if reservations_data is None:
            raise serializers.ValidationError("At least one reservation is required")

        for reservation in reservations_data:
            if attrs['production_brewery'] != reservation['equipment'].brewery:
                raise serializers.ValidationError("Equipment does not belong to selected production brewery")
            if not allows_sector_share:
                occupied_sectors = EquipmentReservation.objects.filter(
                    Q(start_date__lt=reservation['end_date']) &
                    Q(end_date__gt=reservation['start_date'])
                ).exclude(
                    reservation_id__contract_brewery=contract
                ).values_list('equipment__sector_id', flat=True)
            else:
                occupied_sectors = EquipmentReservation.objects.filter(
                    Q(start_date__lt=reservation['end_date']) &
                    Q(end_date__gt=reservation['start_date']) &
                    Q(reservation_id__allows_sector_share=False)
                ).exclude(
                    reservation_id__contract_brewery=contract
                ).values_list('equipment__sector_id', flat=True)

            if reservation['equipment'].sector.sector_id in occupied_sectors:
                raise serializers.ValidationError("Sector is already reserved for that period")
        return attrs


    def create(self, validated_data):
        reservations = validated_data.pop('equipment_reservation_requests')
        price = 0
        for reservation in reservations:
            start = reservation['start_date']
            end = reservation['end_date']
            equipment = reservation['equipment']
            price += equipment.daily_price * math.ceil((end - start).total_seconds() / timedelta(days=1).total_seconds())
        validated_data['price'] = price
        reservation = ReservationRequest.objects.create(**validated_data)
        for reservation_data in reservations:
            EqipmentReservationRequest.objects.create(reservation_request=reservation, **reservation_data)

        return reservation


class EquipmentReservationSerializer(serializers.ModelSerializer):
    class Meta:
        model = EquipmentReservation
        fields = '__all__'


class ReservationSerializer(serializers.ModelSerializer):
    equipment_reservations = EquipmentReservationSerializer(many=True)
    class Meta:
        model = Reservation
        fields = '__all__'


class ReservationCreateSerializer(serializers.Serializer):
    reservation_request_id = serializers.IntegerField(required=True)

    def validate(self, attrs):
        brewery = self.context.get('request').user.get_brewery()
        reservation_request_id = attrs['reservation_request_id']

        reservation_request = ReservationRequest.objects.filter(id=reservation_request_id,
                                                                production_brewery=brewery).first()
        if reservation_request is None:
            raise serializers.ValidationError("Reservation request does not exist")

        reservation_request_data = ReservationRequestSerializer(reservation_request).data
        serializer = ReservationRequestSerializer(data=reservation_request_data,
                                                  context={'contract_brewery': reservation_request.contract_brewery})
        serializer.is_valid(raise_exception=True)

        return attrs

    def create(self, validated_data):
        try:
            with transaction.atomic():
                reservation_request = ReservationRequest.objects.prefetch_related(
                    'equipment_reservation_requests').get(id=validated_data['reservation_request_id'])
                reservation = Reservation.objects.create(
                    price=reservation_request.price,
                    brew_size=reservation_request.brew_size,
                    authorised_workers=reservation_request.authorised_workers,
                    production_brewery=reservation_request.production_brewery,
                    contract_brewery=reservation_request.contract_brewery,
                    allows_sector_share=reservation_request.allows_sector_share
                )
                for eq_res_request in reservation_request.equipment_reservation_requests.all():
                    EquipmentReservation.objects.create(
                        selector=EquipmentReservation.EquipmentSelectors.BREW.value,
                        start_date=eq_res_request.start_date,
                        end_date=eq_res_request.end_date,
                        equipment=eq_res_request.equipment,
                        reservation_id=reservation
                    )
                reservation_request.delete()
                return reservation
        except Exception as e:
            raise serializers.ValidationError(str(e))


class RecipeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Recipe
        fields = '__all__'
        extra_kwargs = {'contract_brewery': {'read_only': True}}


class ExecutionLogSerializer(serializers.ModelSerializer):
    class Meta:
        model = ExecutionLog
        fields = '__all__'
        extra_kwargs = {'is_successful': {'read_only': True}}

    def validate(self, attrs):
        contract_brewery = self.context.get('request').user.get_brewery()
        recipe = attrs.get('recipe')
        reservation = attrs.get('reservation')

        if recipe.contract_brewery != contract_brewery:
            raise serializers.ValidationError("Recipe does not exist")
        if reservation.contract_brewery != contract_brewery:
            raise serializers.ValidationError("Reservation does not exist")
        if ExecutionLog.objects.filter(reservation=reservation).exists():
            raise serializers.ValidationError("Execution log for this reservation already exists")
        return attrs


class ExecutionLogEditSerializer(serializers.ModelSerializer):
    class Meta:
        model = ExecutionLog
        fields = ['log', 'is_successful']


class BeerTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = BeerType
        fields = '__all__'


class CleanupSerializer(serializers.ModelSerializer):
    class Meta:
        model = EquipmentReservation
        fields = ['start_date', 'end_date', 'equipment', 'selector']
        extra_kwargs = {'selector': {'read_only': True}}

    def validate(self, attrs):
        production_brewery = self.context.get('request').user.get_brewery()
        try:
            equipment = Equipment.objects.get(equipment_id=attrs['equipment'].equipment_id,
                                              brewery=production_brewery)
        except Equipment.DoesNotExist:
            raise serializers.ValidationError("Equipment does not exist")
        if EquipmentReservation.objects.filter(
                                        equipment=attrs['equipment'],
                                        start_date__lt=attrs['end_date'],
                                        end_date__gt=attrs['start_date']).exists():

            raise serializers.ValidationError("Equipment is already reserved for that period")
        return attrs


class BreweryStatisticsSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    type = serializers.ChoiceField(choices=[el for el in Brewery.BrewerySelectors.values])
    name = serializers.CharField()
    produced_beer = serializers.FloatField()
    failed_beer_percentage = serializers.FloatField()
    beer_in_production = serializers.FloatField()


class CombinedStatisticsSerializer(serializers.Serializer):
    all_contract = serializers.IntegerField()
    all_production = serializers.IntegerField()
    total_beer_produced = serializers.FloatField()
    total_beer_in_production = serializers.FloatField()
    total_failed_percentage = serializers.FloatField()





