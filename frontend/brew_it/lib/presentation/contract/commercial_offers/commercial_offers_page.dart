import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/errors/error_handlers.dart';
import 'package:brew_it/presentation/_common/templates/table_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/contract/commercial_offers/choose_machine_set_page.dart';
import 'package:brew_it/presentation/contract/commercial_offers/commercial_offers_filter_page.dart';
import 'package:flutter/material.dart';

class CommercialOffersPage extends TablePageTemplate {
  CommercialOffersPage([Map? filtersData, List? filteredElements])
      : super(
            title: "Browary spełniające warunki:",
            buttons: [
              MainButton(
                "FILTRUJ",
                type: "primary_small",
                navigateToPage: () {
                  return filtersData != null
                      ? CommercialOffersFilterPage(filtersData)
                      : CommercialOffersFilterPage({});
                },
              ),
              MainButton(
                "Wyczyść filtry",
                type: "secondary_small",
                navigateToPage: () {
                  return CommercialOffersPage();
                },
              )
            ],
            headers: CommercialOffersFieldNames().fieldNamesTable,
            options: [
              MyIconButton(
                type: "configure",
                navigateToPage: (Map commercialBreweryData,
                    [Map? filtersData]) {
                  return ChooseMachineSetPage(
                      commercialBreweryData, filtersData);
                },
                filtersData: filtersData,
              ),
            ],
            apiString: "/breweries/",
            jsonFields: CommercialOffersFieldNames().jsonFieldNamesTable,
            passedElements: filteredElements,
            filtersPanel: FiltersPanel({}));
}

class FiltersPanel extends StatefulWidget {
  FiltersPanel(this.elementData, {super.key});

  Map elementData;

  @override
  State<FiltersPanel> createState() => _FiltersPanelState();
}

class _FiltersPanelState extends State<FiltersPanel> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.filter_alt),
      title: const Text("Filtruj"),
      onExpansionChanged: (bool currentIsExpanded) {
        setState(() {
          isExpanded = currentIsExpanded;
        });
      },
      // trailing: Row(
      //   children: [
      //     MainButton(
      //       "Aplikuj filtry",
      //       type: "primary_small",
      //       apiCall: "/breweries/filtered/",
      //       apiCallType: "post_use_response_data",
      //       formKey: GlobalKey<FormState>(),
      //       navigateToPage: (Map elementData, List filteredElements) {
      //         return CommercialOffersPage(elementData, filteredElements);
      //       },
      //       dataForPage: widget.elementData,
      //       errorMessages: CommercialOffersFiltersFieldNames().errorMessages,
      //       customErrorHandler: handleMultipleErrors,
      //     ),
      //     MainButton(
      //       "Anuluj",
      //       type: "secondary_small",
      //       // pop: true,
      //     )
      //   ],
      // ),
      children: [
        SizedBox(height: 300, child: CommercialOffersFilterPage({}))
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     Column(
        //       children: [
        //         Text('Ogólne'),
        //       ],
        //     ),
        //     Column(
        //       children: [
        //         Text('Zbiornik'),
        //       ],
        //     ),
        //     Column(
        //       children: [
        //         Text('Zestaw do warzenia'),
        //       ],
        //     ),
        //   ],
        // )
      ],
    );
  }
}
