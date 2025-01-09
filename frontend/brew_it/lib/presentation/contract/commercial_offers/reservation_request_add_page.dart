import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/add_edit_page_template.dart';
import 'package:brew_it/presentation/contract/commercial_offers/commercial_offers_page.dart';
import 'package:brew_it/presentation/contract/reservations/reservation_details_page.dart';

class ReservationRequestAddPage extends AddEditPageTemplate {
  ReservationRequestAddPage(Map elementData, {super.key})
      : super(
            title: "Podsumowanie rezerwacji:",
            apiCall: "/reservation-requests/",
            apiCallType: "post",
            navigateToPageSave: (Map elementData) {
              return ReservationDetailsPage(elementData);
            },
            navigateToPageCancel: () {
              return CommercialOffersPage();
            },
            fieldNames: ReservationsContractFieldNames().fieldNames,
            jsonFieldNames: ReservationsContractFieldNames().jsonFieldNames,
            fieldEditable: [false, false, true, false, false, true],
            elementData: elementData);
}
