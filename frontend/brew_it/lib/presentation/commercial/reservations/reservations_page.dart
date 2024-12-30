import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/table_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/commercial/reservations/reservation_details_page.dart';

class ReservationsPage extends TablePageTemplate {
  ReservationsPage({super.key})
      : super(
            title: "Twoje rezerwacje:",
            headers: ReservationsFieldNames().fieldNamesTable,
            options: [
              MyIconButton(
                type: "info",
                navigateToPage: (Map elementData) {
                  return ReservationDetailsPage(elementData);
                },
              ),
              MyIconButton(type: "delete")
            ],
            // MOCK - check names used in api
            apiString: "/reservations/",
            jsonFields: ReservationsFieldNames().jsonFieldNamesTable);
}
