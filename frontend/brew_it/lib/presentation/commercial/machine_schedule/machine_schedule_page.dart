import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/table_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/commercial/machines/machines_page.dart';
import 'package:brew_it/presentation/contract/reservations_page.dart';

class MachineSchedulePage extends TablePageTemplate {
  // MOCK - pass machine id as a parameter?
  MachineSchedulePage({super.key})
      : super(
            title: "Daty zarezerwowania urządzenia:",
            button:
                MainButton("Powrót", type: "primary_small", navigateToPage: () {
              // MOCK - navigate to previous page
              return MachinesPage();
            }),
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
            // MOCK - check names used in api
            apiString: "/machine_schedule/",
            jsonFields: MachineScheduleFieldNames().jsonFieldNamesTable);
}
