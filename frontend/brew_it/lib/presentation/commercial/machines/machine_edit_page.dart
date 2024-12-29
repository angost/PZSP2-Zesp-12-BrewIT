import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/add_edit_page_template.dart';
import 'package:brew_it/presentation/commercial/machines/machine_details_page.dart';

class MachineEditPage extends AddEditPageTemplate {
  MachineEditPage(Map elementData, {super.key})
      : super(
            title: "Urządzenie - edytuj:",
            apiCall: "/equipment/" + elementData["equipment_id"].toString() + "/",
            apiCallType: "put",
            navigateToPageSave: (Map elementData) {
              return MachineDetailsPage(elementData);
            },
            navigateToPageCancel: (Map elementData) {
              return MachineDetailsPage(elementData);
            },
            fieldNames: MachinesFieldNames().fieldNames,
            jsonFieldNames: MachinesFieldNames().jsonFieldNames,
            fieldEditable: [false, true, true],
            elementData: elementData);
}
