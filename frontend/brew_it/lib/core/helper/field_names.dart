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
