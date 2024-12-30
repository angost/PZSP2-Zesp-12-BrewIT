import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/table_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/commercial/reservation_requests/reservation_request_details_page.dart';

class ReservationRequestsPage extends TablePageTemplate {
  ReservationRequestsPage({super.key})
      : super(
            title: "Prośby o rezerwację:",
            headers: ReservationRequestsFieldNames().fieldNamesTable,
            options: [
              MyIconButton(
                type: "info",
                navigateToPage: (Map elementData) {
                  return ReservationRequestDetailsPage(elementData);
                },
              ),
              MyIconButton(type: "accept"),
              MyIconButton(type: "cancel"),
            ],
            // MOCK - check names used in api
            apiString: "/reservation_requests/",
            jsonFields: ReservationRequestsFieldNames().jsonFieldNamesTable);
}
