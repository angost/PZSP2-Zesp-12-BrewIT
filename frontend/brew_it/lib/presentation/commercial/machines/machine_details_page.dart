import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/details_add_edit_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/commercial/machine_schedule/machine_schedule_page.dart';
import 'package:brew_it/presentation/commercial/machines/machine_edit_page.dart';
import 'package:brew_it/presentation/commercial/machines/machines_page.dart';

class MachineDetailsPage extends DetailsAddEditPageTemplate {
  MachineDetailsPage(Map elementData, {super.key})
      : super(
            title: "Urządzenie - szczegóły:",
            buttons: [
              MainButton(
                "Powrót",
                type: "primary_small",
                navigateToPage: () {
                  return MachinesPage();
                },
              )
            ],
            options: [
              MyIconButton(
                  type: "time",
                  navigateToPage: (Map elementData) {
                    return MachineSchedulePage(elementData);
                  },
                  dataForPage: elementData),
              MyIconButton(
                type: "edit",
                navigateToPage: (Map elementData) {
                  return MachineEditPage(elementData);
                },
                dataForPage: elementData,
              ),
              MyIconButton(
                type: "delete",
              ),
            ],
            fieldNames: MachinesFieldNames().fieldNames,
            jsonFieldNames: MachinesFieldNames().jsonFieldNames,
            elementData: elementData);
}
