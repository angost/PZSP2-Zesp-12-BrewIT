abstract class StandardFieldNames {
  StandardFieldNames(
      {required this.fieldNames,
      required this.jsonFieldNames,
      required this.fieldNamesTable,
      required this.jsonFieldNamesTable});

  List<String> fieldNames;
  List<String> jsonFieldNames;
  List<String> fieldNamesTable;
  List<String> jsonFieldNamesTable;
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
        ], fieldNamesTable: [], jsonFieldNamesTable: []);
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
        ], fieldNamesTable: [], jsonFieldNamesTable: []);
}

class ProductionProcessesFieldNames extends StandardFieldNames {
  ProductionProcessesFieldNames()
      : super(fieldNames: [
          "Id",
          "Data początkowa",
          "Data końcowa",
          "Rezerwacja",
          "Przepis",
          "Opis",
          "Czy udany",
        ], jsonFieldNames: [
          "log_id",
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
        ]);
}

class MachinesFieldNames extends StandardFieldNames {
  MachinesFieldNames()
      : super(fieldNames: [
          "Id",
          "Typ",
          "Nazwa",
          "Opis",
          "Cena za dzień",
          "Pojemność",
          "Temperatura minimalna",
          "Temperatura maksymalna",
          "Sektor",
        ], jsonFieldNames: [
          "equipment_id",
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
        ]);
}

class SectorsFieldNames extends StandardFieldNames {
  SectorsFieldNames()
      : super(fieldNames: [
          "Id",
          "Nazwa",
          "Zezwala na bakterie",
        ], jsonFieldNames: [
          "sector_id",
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
        ]);
}

class ReservationRequestsFieldNames extends StandardFieldNames {
  ReservationRequestsFieldNames()
      : super(fieldNames: [
          //"Id",
          "Browar kontraktowy",
          "Ilość produkowanego piwa",
          "Cena",
          "Pozwala na dzielenie sektorów",
          "Osoby upoważnione do wstępu",
          // "Maszyny"
        ], jsonFieldNames: [
          //"id",
          "contract_brewery",
          "brew_size",
          "price",
          "allows_sector_share",
          "authorised_workers",
          // "equipment_reservation_requests",
        ], fieldNamesTable: [
          //"Id",
          "Browar kontraktowy",
          "Ilość produkowanego piwa",
          "Cena",
          "Pozwala na dzielenie sektorów",
          "Operacje",
        ], jsonFieldNamesTable: [
          // "id",
          "contract_brewery",
          "brew_size",
          "price",
          "allows_sector_share",
        ]);
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
        ]);
}

class MachineScheduleFieldNames extends StandardFieldNames {
  MachineScheduleFieldNames()
      : super(fieldNames: [], jsonFieldNames: [], fieldNamesTable: [
          "Id",
          "Typ rezerwacji",
          "Data początkowa",
          "Data końcowa",
          "Rezerwacja",
          "Operacje",
        ], jsonFieldNamesTable: [
          "id",
          "selector",
          "start_date",
          "end_date",
          "reservation_id",
        ]);
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
        ]);
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
        ]);
}

class RecipesFieldNames extends StandardFieldNames {
  RecipesFieldNames()
      : super(fieldNames: [
          "Id",
          "Typ piwa",
          "Treść",
        ], jsonFieldNames: [
          "recipe_id",
          "beer_type",
          "recipe_body",
        ], fieldNamesTable: [
          "Id",
          "Typ piwa",
          "Operacje",
        ], jsonFieldNamesTable: [
          "recipe_id",
          "beer_type",
        ]);
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
          "account_id",
          "role",
          "name",
          "email"
        ]);
}

class StatisticsFieldNames extends StandardFieldNames {
  StatisticsFieldNames()
      : super(fieldNames: [
          "Typ browaru",
          "Nazwa",
          "Ilość produkowanego piwa",
          "% Anulowanych rezerwacji",
          "% Nieudanego piwa",
        ], jsonFieldNames: [
          "role",
          "name",
          "amount",
          "cancelled_reservations",
          "failed_beer",
        ], fieldNamesTable: [
          "Id",
          "Typ browaru",
          "Nazwa",
          "Ilość produkowanego piwa",
          "% Anulowanych rezerwacji",
          "% Nieudanego piwa",
          "Operacje"
        ], jsonFieldNamesTable: [
          "brewery_id",
          "role",
          "name",
          "amount",
          "cancelled_reservations",
          "failed_beer",
        ]);
}

class StatisticsSumFieldNames extends StandardFieldNames {
  StatisticsSumFieldNames()
      : super(fieldNames: [
          "Liczba browarów komercyjnych",
          "Liczba browarów kontraktowych",
          "Sumaryczna ilość produkowanego piwa",
          "Sumaryczny % anulowanych rezerwacji",
          "Sumaryczny % nieudanego piwa",
        ], jsonFieldNames: [
          "commercial_number",
          "contract_number",
          "amount",
          "sum_cancelled_reservations",
          "sum_failed_beer",
        ], fieldNamesTable: [], jsonFieldNamesTable: []);
}
