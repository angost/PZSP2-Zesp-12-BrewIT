import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/table_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/contract/commercial_offers/commercial_offers_filter_page.dart';

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
              MyIconButton(type: "configure"),
            ],
            apiString: "/breweries/",
            jsonFields: CommercialOffersFieldNames().jsonFieldNamesTable,
            passedElements: filteredElements);
}
