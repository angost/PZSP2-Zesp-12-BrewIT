from .models import Equipment, EquipmentReservation, Reservation, Brewery, Sector
from django.db.models import Q

def filter_equipment(parameters: dict):
    # start_date
    # end_date
    # capacity
    # min_temperature
    # max_temperature
    # production_brewery
    # contract_brewery
    # allows_bacteria
    # selector
    # allows_sector_share
    # package_type

    equimpment = Equipment.objects.all()

    equimpment = equimpment.filter(
        Q(capacity__gte=parameters['capacity']) &
        Q(selector=parameters['selector'])
    )

    if parameters.get('uses_bacteria'):
        equimpment = equimpment.filter(sector__allows_bacteria=True)

    if parameters.get('production_brewery'):
        equimpment = equimpment.filter(brewery=parameters['production_brewery'])

    if parameters.get('selector') == Equipment.EquipmentSelectors.VAT.value:
        equimpment = equimpment.filter(
            Q(vat_packaging__packaging_type=parameters['package_type']) &
            Q(min_temperature__lte=parameters['min_temperature']) &
            Q(max_temperature__gte=parameters['max_temperature'])
        )

    alredy_reserved = equimpment.filter(
        Q(reservations__start_date__lt=parameters['end_date']) &
        Q(reservations__end_date__gt=parameters['start_date'])
    ).distinct().values_list('equipment_id', flat=True)

    equimpment = equimpment.exclude(equipment_id__in=alredy_reserved)

    if not parameters['allows_sector_share']:
        occupied_sectors = EquipmentReservation.objects.filter(
            Q(start_date__lt=parameters['end_date']) &
            Q(end_date__gt=parameters['start_date'])
        ).exclude(
            reservation_id__contract_brewery=parameters['contract_brewery']
        ).values_list('equipment__sector_id', flat=True)

        equimpment = equimpment.exclude(sector_id__in=occupied_sectors)

    return equimpment


def filter_breweries(parameters: dict):
    # VAT:
    # vat_start_date
    # vat_end_date
    # vat_capacity
    # vat_min_temperature
    # vat_max_temperature
    # vat_package_type

    # BREWSET:
    # brewset_start_date
    # brewset_end_date
    # brewset_capacity

    # BOTH:
    # allows_bacteria
    # selector (inplictly)
    # allows_sector_share
    # contract_brewery

    vat_parameters = {
        'start_date': parameters['vat_start_date'],
        'end_date': parameters['vat_end_date'],
        'capacity': parameters['vat_capacity'],
        'min_temperature': parameters['vat_min_temperature'],
        'max_temperature': parameters['vat_max_temperature'],
        'uses_bacteria': parameters['uses_bacteria'],
        'selector': Equipment.EquipmentSelectors.VAT.value,
        'allows_sector_share': parameters['allows_sector_share'],
        'package_type': parameters['vat_package_type'],
        'contract_brewery': parameters['contract_brewery'],
    }

    brewset_parameters = {
        'start_date': parameters['brewset_start_date'],
        'end_date': parameters['brewset_end_date'],
        'capacity': parameters['brewset_capacity'],
        'uses_bacteria': parameters['uses_bacteria'],
        'selector': Equipment.EquipmentSelectors.BREWSET.value,
        'allows_sector_share': parameters['allows_sector_share'],
        'contract_brewery': parameters['contract_brewery'],
    }

    available_vats = filter_equipment(vat_parameters)
    available_brewsets = filter_equipment(brewset_parameters)

    breweries_with_vats = available_vats.values_list('brewery_id', flat=True)
    breweries_with_brewsets = available_brewsets.values_list('brewery_id', flat=True)

    available_breweries = Brewery.objects.filter(
        brewery_id__in=set(breweries_with_vats).intersection(breweries_with_brewsets)
    )
    available_breweries = available_breweries.filter(
        Q(water_ph__gte=parameters['water_ph_min']) &
        Q(water_ph__lte=parameters['water_ph_max'])
    )

    return available_breweries
