import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/add_edit_page_template.dart';
import 'package:brew_it/presentation/commercial/machines/machine_details_page.dart';
import 'package:brew_it/presentation/commercial/machines/machines_page.dart';

class MachineAddPage extends AddEditPageTemplate {
  MachineAddPage(Map elementData, {super.key})
      : super(
            title: "Dodaj nowe urządzenie:",
            apiCall: "/equipment/",
            apiCallType: "post",
            navigateToPageSave: (Map elementData) {
              return MachineDetailsPage(elementData);
            },
            navigateToPageCancel: () {
              return MachinesPage();
            },
            fieldNames: MachinesFieldNames().fieldNames,
            jsonFieldNames: MachinesFieldNames().jsonFieldNames,
            errorMessages: MachinesFieldNames().errorMessages,
            fieldEditable: [
              true,
              true,
              true,
              true,
              true,
              true,
              true,
              true
            ],
            fieldTypes: MachinesFieldNames().fieldTypes,
            fetchOptions: MachinesFieldNames().fetchOptions,
            enumOptions: {
              "selector": [
                {"display": "Zestaw do warzenia", "apiValue": "BREWSET"},
                {"display": "Zbiornik", "apiValue": "VAT"},
              ],
              "sector": []
            },
            elementData: elementData);
}
