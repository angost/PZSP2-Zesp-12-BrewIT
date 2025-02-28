import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/add_edit_page_template.dart';
import 'package:brew_it/presentation/contract/production_processes/production_process_details_page.dart';
import 'package:brew_it/presentation/contract/production_processes/production_processes_page.dart';

class ProductionProcessAddPage extends AddEditPageTemplate {
  ProductionProcessAddPage(Map elementData, {super.key})
      : super(
            title: "Dodaj nowy proces wykonania:",
            apiCall: "/execution-logs/",
            apiCallType: "post",
            navigateToPageSave: (Map elementData) {
              return ProductionProcessDetailsPage(elementData);
            },
            navigateToPageCancel: () {
              return ProductionProcessesPage();
            },
            fieldNames: ProductionProcessesFieldNames().fieldNames,
            jsonFieldNames: ProductionProcessesFieldNames().jsonFieldNames,
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
              true
            ],
            fieldTypes: ProductionProcessesFieldNames().fieldTypes,
            errorMessages: ProductionProcessesFieldNames().errorMessages,
            fetchOptions: ProductionProcessesFieldNames().fetchOptions,
            elementData: elementData);
}
