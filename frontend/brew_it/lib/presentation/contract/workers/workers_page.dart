import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/table_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';

import 'package:brew_it/presentation/contract/workers/worker_add_page.dart';
import 'package:brew_it/presentation/contract/workers/worker_details_page.dart';

class WorkersPage extends TablePageTemplate {
  WorkersPage({super.key})
      : super(
            title: "Twoi pracownicy:",
            buttons: [MainButton("Dodaj pracownika", type: "secondary_small",
                navigateToPage: () {
              return WorkerAddPage({});
            })],
            headers: WorkerFieldNames().fieldNamesTable,
            options: [
              MyIconButton(
                type: "info",
                navigateToPage: (Map elementData) {
                  return WorkerDetailsPage(elementData);
                },
              ),
              // MyIconButton(
              //   type: "edit",
              //   navigateToPage: (Map elementData) {
              //     return RecipeEditPage(elementData);
              //   },
              // ),

            ],
            apiString: "/workers/",
            fetchDisplay: [],
            hideFirstField: true,
            jsonFields: WorkerFieldNames().jsonFieldNamesTable);
}