import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/details_add_edit_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/commercial/reservation_requests/reservation_requests_page.dart';

class ReservationRequestDetailsPage extends DetailsAddEditPageTemplate {
  ReservationRequestDetailsPage(Map elementData, {super.key})
      : super(
            title: "Prośba o rezerwację - szczegóły:",
            buttons: [
              MainButton(
                "Powrót",
                type: "primary_small",
                navigateToPage: () {
                  return ReservationRequestsPage();
                },
              )
            ],
            options: [
              // MOCK - api call required
              MyIconButton(
                type: "accept",
                navigateToPage: () {
                  return ReservationRequestsPage();
                },
              ),
              MyIconButton(
                type: "cancel",
                navigateToPage: () {
                  return ReservationRequestsPage();
                },
              ),
            ],
            fieldNames: ReservationRequestsFieldNames().fieldNames,
            jsonFieldNames: ReservationRequestsFieldNames().jsonFieldNames,
            elementData: elementData);
}
