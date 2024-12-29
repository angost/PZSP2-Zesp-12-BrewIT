import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/add_edit_page_template.dart';
import 'package:brew_it/presentation/contract/production_processes/production_process_details_page.dart';

class ProductionProcessEditPage extends AddEditPageTemplate {
  ProductionProcessEditPage(Map elementData, {super.key})
      : super(
            title: "Proces wykonania - edytuj:",
            apiCall: "",
            apiCallType: "put",
            navigateToPageSave: (Map elementData) {
              return ProductionProcessDetailsPage(elementData);
            },
            navigateToPageCancel: (Map elementData) {
              return ProductionProcessDetailsPage(elementData);
            },
            fieldNames: ProductionProcessesFieldNames().fieldNames,
            jsonFieldNames: ProductionProcessesFieldNames().jsonFieldNames,
            fieldEditable: [false, false, false, false, false, true],
            elementData: elementData);
}
