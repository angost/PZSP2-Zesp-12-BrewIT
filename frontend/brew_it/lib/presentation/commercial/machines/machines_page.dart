import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/table_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/commercial/machines/machine_add_page.dart';
import 'package:brew_it/presentation/commercial/machines/machine_details_page.dart';
import 'package:brew_it/presentation/commercial/machines/machine_edit_page.dart';

class MachinesPage extends TablePageTemplate {
  MachinesPage({super.key})
      : super(
            title: "Twoje urządzenia:",
            button: MainButton("Dodaj urządzenie", type: "secondary_small",
                navigateToPage: () {
              return MachineAddPage({});
            }),
            headers: MachinesFieldNames().fieldNamesTable,
            options: [
              MyIconButton(
                type: "info",
                navigateToPage: (Map elementData) {
                  return MachineDetailsPage(elementData);
                },
              ),
              MyIconButton(type: "time"),
              MyIconButton(
                type: "edit",
                navigateToPage: (Map elementData) {
                  return MachineEditPage(elementData);
                },
              ),
              MyIconButton(type: "delete")
            ],
            apiString: "/equipment/",
            jsonFields: MachinesFieldNames().jsonFieldNamesTable);
}
