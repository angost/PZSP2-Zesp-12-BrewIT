import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/details_add_edit_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/contract/commercial_offers/commercial_offers_page.dart';
import 'package:flutter/material.dart';

class CommercialOffersFilterPage extends DetailsAddEditPageTemplate {
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
              }, dataForPage: elementData),
              MainButton(
                "Anuluj",
                type: "secondary_small",
                pop: true,
              )
            ],
            fieldNames: CommercialOffersFiltersFieldNames().fieldNames,
            jsonFieldNames: CommercialOffersFiltersFieldNames().jsonFieldNames,
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
            elementData: elementData);
}
