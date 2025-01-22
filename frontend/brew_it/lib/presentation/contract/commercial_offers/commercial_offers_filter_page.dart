import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/filter_page_template.dart';
import 'package:flutter/material.dart';

class CommercialOffersFilterPage extends FilterPageTemplate {
  CommercialOffersFilterPage(Map elementData, GlobalKey<FormState> formKey,
      {super.key})
      : super(
          title: "Filtruj browary komercyjne:",
          formKey: formKey,
          fieldNames: CommercialOffersFiltersFieldNames().fieldNames,
          jsonFieldNames: CommercialOffersFiltersFieldNames().jsonFieldNames,
          fieldTypes: [
            "DatePickerField", // Zbiornik - data początkowa
            "DatePickerField", // Zbiornik - data końcowa
            "TextField", // Zbiornik - pojemność
            "TextField", // Zbiornik - temperatura minimalna
            "TextField", // Zbiornik - temperatura maksymalna
            "EnumField", // Zbiornik - typ pakowania
            "DatePickerField", // Zestaw do warzenia - data początkowa
            "DatePickerField", // Zestaw do warzenia - data końcowa
            "TextField", // Zestaw do warzenia - pojemność
            "BooleanField", // Zezwala na bakterie
            "BooleanField", // Zezwala na dzielenie sektorów
            "TextField", // Ph wody minimalne
            "TextField", // Ph wody maksymalne
          ],
          enumOptions: {
            "vat_package_type": [
              {"display": "Kegi", "apiValue": "KEG"},
              {"display": "Butelki", "apiValue": "BOTTLE"},
              {"display": "Puszki", "apiValue": "CAN"},
            ],
          },
          fieldEditable: [
            true,
            true,
            true,
            true,
            true,
            true,
            true,
            true,
            true,
            true,
            true,
            true,
            true,
          ],
          elementData: elementData,
        );
}
