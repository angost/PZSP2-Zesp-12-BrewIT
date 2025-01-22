import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/add_edit_page_template.dart';
import 'package:brew_it/presentation/commercial/brewery_data/brewery_data_page.dart';

class BreweryDataEditPage extends AddEditPageTemplate {
  BreweryDataEditPage(Map elementData, {super.key})
      : super(
            title: "Dane browaru - edytuj:",
            apiCall: "/breweries/me/",
            apiCallType: "put",
            navigateToPageSave: (Map elementData) {
              return BreweryDataPage(elementData);
            },
            navigateToPageCancel: (Map elementData) {
              return BreweryDataPage(elementData);
            },
            fieldNames: BreweryDataFieldNames().fieldNames,
            jsonFieldNames: BreweryDataFieldNames().jsonFieldNames,
            fieldEditable: [false, true, true, true],
            fieldTypes: BreweryDataFieldNames().fieldTypes,
            errorMessages: BreweryDataFieldNames().errorMessages,
            elementData: elementData);
}
