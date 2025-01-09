import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/table_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/commercial/machines/machine_details_page.dart';
import 'package:brew_it/presentation/commercial/reservations/reservations_page.dart';

class MachineSchedulePage extends TablePageTemplate {
  MachineSchedulePage(Map elementData, {super.key})
      : super(
            title: "Daty zarezerwowania urządzenia:",
            button: MainButton("Powrót", type: "primary_small",
                navigateToPage: (Map elementData) {
              return MachineDetailsPage(elementData);
            }, dataForPage: elementData),
            headers: MachineScheduleFieldNames().fieldNamesTable,
            options: [
              MyIconButton(
                type: "link",
                navigateToPage: () {
                  // MOCK - navigate to reservation details page
                  return ReservationsPage();
                },
              ),
            ],
            apiString:
                "/equipment-reservations/?equipment=${elementData["equipment_id"]}",
            jsonFields: MachineScheduleFieldNames().jsonFieldNamesTable);
}
