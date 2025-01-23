import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/details_add_edit_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/contract/workers/workers_page.dart';

class WorkerDetailsPage extends DetailsAddEditPageTemplate {
  WorkerDetailsPage(Map elementData, {super.key})
      : super(
            title: "Pracownik - szczegóły:",
            buttons: [
              MainButton(
                "Powrót",
                type: "primary_small",
                pop: true,
              )
            ],
            options: [
              // MyIconButton(
              //   type: "edit",
              //   navigateToPage: (Map elementData) {
              //     return RecipeEditPage(elementData);
              //   },
              //   dataForPage: elementData,
              // ),
              MyIconButton(
                type: "delete",
                apiCall: "/workers/",
                apiCallType: "delete",
                elementId: elementData["id"],
                navigateToPage: () {
                  return WorkersPage();
                },
              ),
            ],
            fieldNames: WorkerFieldNames().fieldNames,
            jsonFieldNames: WorkerFieldNames().jsonFieldNames,
            fieldTypes: WorkerFieldNames().fieldTypes,
            fetchOptions: WorkerFieldNames().fetchOptions,
            elementData: elementData);
}