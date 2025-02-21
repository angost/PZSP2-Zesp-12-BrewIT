import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/add_edit_page_template.dart';
import 'package:brew_it/presentation/contract/workers/worker_details_page.dart';
import 'package:brew_it/presentation/contract/workers/workers_page.dart';

class WorkerAddPage extends AddEditPageTemplate {
  WorkerAddPage(Map elementData, {super.key})
      : super(
            title: "Dodaj pracownika:",
            apiCall: "/workers/",
            apiCallType: "post",
            navigateToPageSave: (Map elementData) {
              return WorkersPage();
            },
            navigateToPageCancel: () {
              return WorkersPage();
            },
            fieldNames: WorkerFieldNames().fieldNames,
            jsonFieldNames: WorkerFieldNames().jsonFieldNames,
            fieldEditable: [false, true, true, false],
            fieldTypes: WorkerFieldNames().fieldTypes,
            errorMessages: WorkerFieldNames().errorMessages,
            fetchOptions: WorkerFieldNames().fetchOptions,
            elementData: elementData);
}