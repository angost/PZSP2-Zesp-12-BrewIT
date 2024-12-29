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
            fieldEditable: [true, true, true],
            elementData: {"selector": "PROD", "sector": "1", ...elementData});
}
