import 'package:flutter/material.dart';

abstract class StandardFieldNames {
  StandardFieldNames(
      {required this.fieldNames,
      required this.jsonFieldNames,
      required this.fieldNamesTable,
      required this.jsonFieldNamesTable,
      required this.fieldTypes,
      required this.errorMessages,
      this.fetchOptions
      });

  List<String> fieldNames;
  List<String> jsonFieldNames;
  List<String> fieldNamesTable;
  List<String> jsonFieldNamesTable;
  List<String> fieldTypes;
  Map<String, dynamic> errorMessages;
  List<Map<String, String>>? fetchOptions;
}

class RegisterCommercialFieldNames extends StandardFieldNames {
  RegisterCommercialFieldNames()
      : super(fieldNames: [
          "Email",
          "Hasło",
          "Powtórz hasło",
          "Nazwa firmy",
          "NIP",
          "Ph wody",
        ], jsonFieldNames: [
          "email",
          "password",
          "password2",
          "name",
          "nip",
          "water_ph"
        ],
      fieldNamesTable: [],
      jsonFieldNamesTable: [],
      fieldTypes: [],
      errorMessages: {
        "email": {
          "This field may not be blank.": "Email nie może być pusty.",
          "Enter a valid email address.": "Wprowadź poprawny adres email.",
          "Account with this email already exists": "Istnieje już konto z tym adresem email."
        },
        "password": {
          "This field may not be blank.": "Hasło nie może być puste",
          "This password is too short. It must contain at least 8 characters.": "Hasło musi mieć co najmniej 8 znaków.",
          "This password is too common.": "Zbyt popularne hasło."
        },
        "password2": {"This field may not be blank.": "Należy powtórzyć hasło."},
        "name": {"This field may not be blank.": "Nazwa firmy nie może być pusta."},
        "water_ph": {
          "Ensure that there are no more than 2 digits before the decimal point.": "Ph wody powinno mieć format XX.X.",
        },
        "non_field_errors": {
          "Passwords do not match": "Powtórzone hasło nie jest identyczne.",
          "Production brewery must specify water_ph": "Wymagane jest ph wody w browarze",
        },
      });
}

class RegisterContractFieldNames extends StandardFieldNames {
  RegisterContractFieldNames()
      : super(fieldNames: [
          "Email",
          "Hasło",
          "Powtórz hasło",
          "Nazwa firmy",
          "NIP",
        ], jsonFieldNames: [
          "email",
          "password",
          "password2",
          "name",
          "nip",
        ],
      fieldNamesTable: [],
      jsonFieldNamesTable: [],
      fieldTypes: [],
      errorMessages: {
        "email": {
          "This field may not be blank.": "Email nie może być pusty.",
          "Enter a valid email address.": "Wprowadź poprawny adres email.",
          "Account with this email already exists": "Istnieje już konto z tym adresem email."
        },
        "password": {
          "This field may not be blank.": "Hasło nie może być puste",
          "This password is too short. It must contain at least 8 characters.": "Hasło musi mieć co najmniej 8 znaków.",
          "This password is too common.": "Zbyt popularne hasło."
        },
        "password2": {"This field may not be blank.": "Należy powtórzyć hasło."},
        "name": {"This field may not be blank.": "Nazwa firmy nie może być pusta."},
        "non_field_errors": {
          "Passwords do not match": "Powtórzone hasło nie jest identyczne.",
          "Production brewery must specify water_ph": "Wymagane jest ph wody w browarze",
        },
      });
}

class CommercialOffersFieldNames extends StandardFieldNames {
  CommercialOffersFieldNames()
      : super(fieldNames: [
          "Id",
          "Nazwa",
          "NIP",
          "Ph wody",
        ], jsonFieldNames: [
          "brewery_id",
          "name",
          "nip",
          "water_ph"
        ], fieldNamesTable: [
          "Id",
          "Nazwa",
          "NIP",
          "Ph wody",
          "Operacje"
        ], jsonFieldNamesTable: [
          "brewery_id",
          "name",
          "nip",
          "water_ph"
        ], fieldTypes: [], errorMessages: {});
}

class CommercialOffersFiltersFieldNames extends StandardFieldNames {
  CommercialOffersFiltersFieldNames()
      : super(fieldNames: [
          "Zbiornik - data początkowa",
          "Zbiornik - data końcowa",
          "Zbiornik - pojemność",
          "Zbiornik - temperatura minimalna",
          "Zbiornik - temperatura maksymalna",
          "Zbiornik - typ pakowania",
          "Zestaw do warzenia - data początkowa",
          "Zestaw do warzenia - data końcowa",
          "Zestaw do warzenia - pojemność",
          "Używa bakterii",
          "Zezwala na dzielenie sektorów",
          "Ph wody minimalne",
          "Ph wody maksymalne",
        ], jsonFieldNames: [
          "vat_start_date",
          "vat_end_date",
          "vat_capacity",
          "vat_min_temperature",
          "vat_max_temperature",
          "vat_package_type",
          "brewset_start_date",
          "brewset_end_date",
          "brewset_capacity",
          "uses_bacteria",
          "allows_sector_share",
          "water_ph_min",
          "water_ph_max"
        ],
      fieldNamesTable: [],
      jsonFieldNamesTable: [],
      fieldTypes: [],
      errorMessages: {
        "vat_start_date": "Data początkowa zbiornika jest wymagana.",
        "vat_end_date": "Data końcowa zbiornika jest wymagana.",
        "vat_capacity": "Pojemność zbiornika musi być liczbą całkowitą.",
        "vat_min_temperature": "Minimalna temperatura zbiornika musi być liczbą.",
        "vat_max_temperature": "Maksymalna temperatura zbiornika musi być liczbą.",
        "vat_package_type": "Typ opakowania zbiornika jest wymagany.",
        "brewset_start_date": "Data początkowa zestawu do warzenia jest wymagana.",
        "brewset_end_date": "Data końcowa zestawu do warzenia jest wymagana.",
        "brewset_capacity": "Pojemność zestawu do warzenia musi być liczbą całkowitą.",
        "uses_bacteria": "Pole 'Używa bakterii' jest wymagane.",
        "allows_sector_share": "Pole 'Zezwala na współdzielenie sektora' jest wymagane.",
        "water_ph_min": "Minimalne pH wody musi być liczbą.",
        "water_ph_max": "Maksymalne pH wody musi być liczbą.",});
}

class ProductionProcessesFieldNames extends StandardFieldNames {
  ProductionProcessesFieldNames()
      : super(fieldNames: [
          "Data początkowa",
          "Data końcowa",
          "Rezerwacja",
          "Przepis",
          "Opis",
          "Czy udany",
        ], jsonFieldNames: [
          "start_date",
          "end_date",
          "reservation",
          "recipe",
          "log",
          "is_successful",
        ], fieldNamesTable: [
          "Id",
          "Data początkowa",
          "Data końcowa",
          "Czy udany",
          "Operacje"
        ], jsonFieldNamesTable: [
          "log_id",
          "start_date",
          "end_date",
          "is_successful"
        ], fieldTypes: [
          "DatePickerField",
          "DatePickerField",
          "EnumField",
          "EnumField",
          "TextField",
          "BooleanField"
        ], errorMessages: {
        "start_date": "Data początkowa jest wymagana.",
        "non_field_errors": {
          "Execution log for this reservation already exists":
            "Dziennik wykonania dla tej rezerwacji już istnieje.",
          "Reservation does not exist": "Rezerwacja nie istnieje.",
        },
        "reservation": {
          "This field may not be null" : "Rezerwacja nie może być pusta.",
          r'Invalid pk "\d+" - object does not exist.': "Taka rezerwacja nie istnieje."
        },
        "recipe": {
          "This field may not be null" : "Przepis nie może być pusty.",
          r'Invalid pk "\d+" - object does not exist.': "Taki przepis nie istnieje."
        }
        }, fetchOptions: [
          {
            "endpoint": "/reservations/",
            "displayField": "reservation_id",
            "apiValueField": "reservation_id",
            "enumKey": "reservation",
          },
          {
            "endpoint": "/recipes/",
            "displayField": "recipe_id",
            "apiValueField": "recipe_id",
            "enumKey": "recipe",
          }
        ]);
}

class MachinesFieldNames extends StandardFieldNames {
  MachinesFieldNames()
      : super(fieldNames: [
          "Typ",
          "Nazwa",
          "Opis",
          "Cena za dzień",
          "Pojemność",
          "Temperatura minimalna",
          "Temperatura maksymalna",
          "Sektor",
        ], jsonFieldNames: [
          "selector",
          "name",
          "description",
          "daily_price",
          "capacity",
          "min_temperature",
          "max_temperature",
          "sector"
        ], fieldNamesTable: [
          "Id",
          "Typ",
          "Nazwa",
          "Cena za dzień",
          "Pojemność",
          "Operacje"
        ], jsonFieldNamesTable: [
          "equipment_id",
          "selector",
          "name",
          "daily_price",
          "capacity",
        ], fieldTypes: [
          "EnumField",
          "TextField",
          "TextField",
          "TextField",
          "TextField",
          "TextField",
          "TextField",
          "EnumField",
        ], errorMessages: {
          "selector": "Typ jest wymagany.",
          "capacity": "Pojemność musi być liczbą całkowitą.",
          "name": "Nazwa nie może być pusta.",
          "daily_price": "Cena musi być liczbą całkowitą.",
          "sector": "Sektor jest wymagany.",
        }, fetchOptions: [
          {
            "endpoint": "/sectors/",
            "displayField": "name",
            "apiValueField": "sector_id",
            "enumKey": "sector",
          }
        ]);
}

class SectorsFieldNames extends StandardFieldNames {
  SectorsFieldNames()
      : super(fieldNames: [
          "Nazwa",
          "Zezwala na bakterie",
        ], jsonFieldNames: [
          "name",
          "allows_bacteria",
        ], fieldNamesTable: [
          "Id",
          "Nazwa",
          "Zezwala na bakterie",
          "Operacje"
        ], jsonFieldNamesTable: [
          "sector_id",
          "name",
          "allows_bacteria",
        ], fieldTypes: [
          "TextField",
          "BooleanField",
        ], errorMessages: {
          "name": "Nazwa nie może być pusta.",
          "allows_bacteria": "Wybrać opcję bakterii",
  });
}

class ReservationRequestsFieldNames extends StandardFieldNames {
  ReservationRequestsFieldNames()
      : super(fieldNames: [
          "Id",
          "Browar kontraktowy",
          "Browar komercyjny",
          "Ilość produkowanego piwa",
          "Cena",
          "Pozwala na dzielenie sektorów",
          "Osoby upoważnione do wstępu",
          // "Maszyny"
        ], jsonFieldNames: [
          "id",
          "contract_brewery",
          "production_brewery",
          "brew_size",
          "price",
          "allows_sector_share",
          "authorised_workers",
          // "equipment_reservation_requests",
        ], fieldNamesTable: [
          "Id",
          "Browar kontraktowy",
          "Ilość produkowanego piwa",
          "Cena",
          "Pozwala na dzielenie sektorów",
          "Operacje",
        ], jsonFieldNamesTable: [
          "id",
          "contract_brewery",
          "brew_size",
          "price",
          "allows_sector_share",
        ], fieldTypes: [
          "TextField",
          "TextField",
          "TextField",
          "TextField",
          "TextField",
          "BooleanField",
          "TextField",
        ], errorMessages: {});
}

class ReservationRequestsContractFieldNames extends StandardFieldNames {
  ReservationRequestsContractFieldNames()
      : super(fieldNames: [
    "Browar komercyjny",
    "Ilość produkowanego piwa",
    "Cena",
    "Pozwala na dzielenie sektorów",
    "Osoby upoważnione do wstępu",
    // "Maszyny"
  ], jsonFieldNames: [
    "production_brewery",
    "brew_size",
    "price",
    "allows_sector_share",
    "authorised_workers",
    // "equipment_reservation_requests",
  ], fieldNamesTable: [
    "Id",
    "Browar kontraktowy",
    "Ilość produkowanego piwa",
    "Cena",
    "Pozwala na dzielenie sektorów",
    "Operacje",
  ], jsonFieldNamesTable: [
    "id",
    "contract_brewery",
    "brew_size",
    "price",
    "allows_sector_share",
  ], fieldTypes: [
    "TextField",
    "TextField",
    "TextField",
    "BooleanField",
    "TextField",
  ], errorMessages: {});
}

class AllowedPeopleFieldNames extends StandardFieldNames {
  AllowedPeopleFieldNames()
      : super(fieldNames: [], jsonFieldNames: [], fieldNamesTable: [
          "Id",
          "Imię",
          "Nazwisko",
          "Browar",
          "Operacje",
        ], jsonFieldNamesTable: [
          "id",
          "name",
          "surname",
          "contract_brewery",
        ], fieldTypes: [], errorMessages: {});
}

class MachineScheduleFieldNames extends StandardFieldNames {
  MachineScheduleFieldNames()
      : super(fieldNames: [], jsonFieldNames: [], fieldNamesTable: [
          "Id",
          "Typ rezerwacji",
          "Data początkowa",
          "Data końcowa",
          "Rezerwacja",
        ], jsonFieldNamesTable: [
          "id",
          "selector",
          "start_date",
          "end_date",
          "reservation_id",
        ], fieldTypes: [], errorMessages: {});
}

class ReservationsCommercialFieldNames extends StandardFieldNames {
  ReservationsCommercialFieldNames()
      : super(fieldNames: [
          "Id",
          "Browar kontraktowy",
          "Ilość produkowanego piwa",
          "Cena",
          "Pozwala na dzielenie sektorów",
          "Osoby upoważnione do wstępu",
          // "Maszyny"
        ], jsonFieldNames: [
          "reservation_id",
          "contract_brewery",
          "brew_size",
          "price",
          "allows_sector_share",
          "authorised_workers",
          // "equipment_reservation_requests",
        ], fieldNamesTable: [
          "Id",
          "Browar kontraktowy",
          "Ilość produkowanego piwa",
          "Cena",
          "Pozwala na dzielenie sektorów",
          "Operacje",
        ], jsonFieldNamesTable: [
          "reservation_id",
          "contract_brewery",
          "brew_size",
          "price",
          "allows_sector_share",
        ], fieldTypes: [], errorMessages: {});
}

class ReservationsContractFieldNames extends StandardFieldNames {
  ReservationsContractFieldNames()
      : super(fieldNames: [
          "Id",
          "Browar komercyjny",
          "Ilość produkowanego piwa",
          "Cena",
          "Pozwala na dzielenie sektorów",
          "Osoby upoważnione do wstępu",
          // "Maszyny"
        ], jsonFieldNames: [
          "reservation_id",
          "production_brewery",
          "brew_size",
          "price",
          "allows_sector_share",
          "authorised_workers",
          // "equipment_reservation_requests",
        ], fieldNamesTable: [
          "Id",
          "Browar komercyjny",
          "Ilość produkowanego piwa",
          "Cena",
          "Pozwala na dzielenie sektorów",
          "Operacje",
        ], jsonFieldNamesTable: [
          "reservation_id",
          "production_brewery",
          "brew_size",
          "price",
          "allows_sector_share",
        ], fieldTypes: [
          "TextField",
          "TextField",
          "TextField",
          "TextField",
          "BooleanField",
          "TextField",
        ], errorMessages: {});
}

class RecipesFieldNames extends StandardFieldNames {
  RecipesFieldNames()
      : super(fieldNames: [
          "Typ piwa",
          "Treść",
        ], jsonFieldNames: [
          "beer_type",
          "recipe_body",
        ], fieldNamesTable: [
          "Id",
          "Typ piwa",
          "Operacje",
        ], jsonFieldNamesTable: [
          "recipe_id",
          "beer_type",
        ], fieldTypes: [
          "EnumField",
          "TextField"
        ], errorMessages: {
          "beer_type": {
            "cannot be empty":
            "Typ piwa nie może być pusty",
            r'Invalid pk "\d+" - object does not exist.': r'Niewłaściwy klucz typu piwa',
          },
          "recipe_body": "Treść nie może mieć więcej niż 2048 znaków."
        }, fetchOptions: [
          {
            "endpoint": "/beer-types/",
            "displayField": "name",
            "apiValueField": "beer_type_id",
            "enumKey": "beer_type",
          }]
  );
}

class RegistrationRequestsFieldNames extends StandardFieldNames {
  RegistrationRequestsFieldNames()
      : super(fieldNames: [], jsonFieldNames: [], fieldNamesTable: [
          "Id",
          "Typ browaru",
          "Nazwa firmy",
          "Email",
          "Operacje",
        ], jsonFieldNamesTable: [
          "id",
          "selector",
          "name",
          "email"
        ], fieldTypes: [], errorMessages: {});
}

class StatisticsFieldNames extends StandardFieldNames {
  StatisticsFieldNames()
      : super(fieldNames: [
          "Id browaru",
          "Typ browaru",
          "Nazwa",
          "Ilość wyprodukowanego piwa",
          "% Nieudanego piwa",
          "Ilość produkowanego teraz piwa",
        ], jsonFieldNames: [
          "id",
          "type",
          "name",
          "produced_beer",
          "failed_beer_percentage",
          "beer_in_production",
        ], fieldNamesTable: [
          "Id browaru",
          "Typ browaru",
          "Nazwa",
          "Ilość wyprodukowanego piwa",
          "% Nieudanego piwa",
          "Ilość produkowanego teraz piwa",
        ], jsonFieldNamesTable: [
          "id",
          "type",
          "name",
          "produced_beer",
          "failed_beer_percentage",
          "beer_in_production",
        ], fieldTypes: [], errorMessages: {});
}

class StatisticsSumFieldNames extends StandardFieldNames {
  StatisticsSumFieldNames()
      : super(fieldNames: [
          "Liczba browarów kontraktowych",
          "Liczba browarów komercyjnych",
          "Sumaryczna ilość wyprodukowanego piwa",
          "Sumaryczna ilość piwa w produkcji",
          "Sumaryczny % nieudanych prcoesów wykonywania piwa",
        ], jsonFieldNames: [
          "all_contract",
          "all_production",
          "total_beer_produced",
          "total_beer_in_production",
          "total_failed_percentage",
        ], fieldNamesTable: [], jsonFieldNamesTable: [], fieldTypes: [], errorMessages: {});
}
