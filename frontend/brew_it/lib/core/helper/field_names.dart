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
          "Typ piwa",
          "Browar komercyjny",
          "Receptura",
          "Daty",
          "Rezerwacja",
          "Czy udany",
        ], jsonFieldNames: [
          // MOCK
          "id",
          "title",
          "completed",
          "id",
          "title",
          "completed",
        ], fieldNamesTable: [
          "Id",
          "Typ piwa",
          "Browar komercyjny",
          "Daty",
          "Czy udany",
          "Operacje"
        ], jsonFieldNamesTable: [
          // MOCK
          "id", "title", "completed"
        ]);
}

class MachinesFieldNames extends StandardFieldNames {
  MachinesFieldNames()
      : super(fieldNames: [
          "Nazwa",
          "Pojemność",
          "Cena za dzień",
        ], jsonFieldNames: [
          "name",
          "capacity",
          "daily_price",
        ], fieldNamesTable: [
          "Id",
          "Nazwa",
          "Pojemność",
          "Cena za dzień",
          "Operacje"
        ], jsonFieldNamesTable: [
          "equipment_id",
          "name",
          "capacity",
          "daily_price",
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
          "capacity",
        ]);
}

class ReservationRequestsFieldNames extends StandardFieldNames {
  ReservationRequestsFieldNames()
      : super(fieldNames: [
          "Browar",
          "Planowana ilość produkowanego piwa",
          "Cena",
        ], jsonFieldNames: [
          "contract_brewery",
          "brew_size",
          "price"
        ], fieldNamesTable: [
          "Id",
          "Browar",
          "Operacje",
        ], jsonFieldNamesTable: [
          "reservation_id",
          "contract_brewery",
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
          "Data początkowa",
          "Data końcowa",
          "Browar",
          "Rezerwacja",
          "Operacje",
        ], jsonFieldNamesTable: [
          "machine_schedule_id",
          "start_date",
          "end_date",
          "reservation_id",
        ]);
}

class ReservationsFieldNames extends StandardFieldNames {
  ReservationsFieldNames()
      : super(fieldNames: [
          "Browar",
          "Data początkowa",
          "Data końcowa",
          "Cena",
          "Planowana ilość produkowanego piwa",
          "Osoby upoważnione do wstępu",
          "Maszyny",
        ], jsonFieldNames: [
          "contract_brewery",
          "brew_size",
          "price",
          "allowed_people",
          "machines"
        ], fieldNamesTable: [
          "Id",
          "Browar",
          "Data początkowa",
          "Data końcowa",
          "Operacje",
        ], jsonFieldNamesTable: [
          "reservation_id",
          "brewery",
          "start_date",
          "end_date",
        ]);
}

class RecipesFieldNames extends StandardFieldNames {
  RecipesFieldNames()
      : super(fieldNames: [
          "Nazwa",
          "Typ piwa",
          "Treść",
        ], jsonFieldNames: [
          "name",
          "beer_type_beer",
          "recipe_body"
        ], fieldNamesTable: [
          "Id",
          "Nazwa",
          "Typ piwa",
          "Operacje",
        ], jsonFieldNamesTable: [
          "recipe_id",
          "name",
          "beer_type_beer"
        ]);
}
