import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/filter_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/contract/commercial_offers/commercial_offers_page.dart';
import 'package:brew_it/presentation/_common/errors/error_handlers.dart';
import 'package:flutter/material.dart';

class CommercialOffersFilterPage extends FilterPageTemplate {
  CommercialOffersFilterPage(Map elementData, {super.key})
      : super(
    title: "Filtruj browary komercyjne:",
    buttons: [
      MainButton("Aplikuj filtry",
          type: "primary_small",
          apiCall: "/breweries/filtered/",
          apiCallType: "post_use_response_data",
          formKey: GlobalKey<FormState>(),
          navigateToPage: (Map elementData, List filteredElements) {
            return CommercialOffersPage(elementData, filteredElements);
          },
          dataForPage: elementData,
          errorMessages: CommercialOffersFiltersFieldNames().errorMessages,
          customErrorHandler: handleMultipleErrors,),
      MainButton(
        "Anuluj",
        type: "secondary_small",
        pop: true,
      )
    ],
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
