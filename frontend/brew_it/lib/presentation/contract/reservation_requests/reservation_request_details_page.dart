import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/details_add_edit_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/contract/reservation_requests/reservation_requests_page.dart';

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
            fieldNames: ReservationRequestsContractFieldNames().fieldNames,
            jsonFieldNames:
                ReservationRequestsContractFieldNames().jsonFieldNames,
            elementData: elementData);
}
