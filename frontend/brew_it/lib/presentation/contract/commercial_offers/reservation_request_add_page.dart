import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/add_edit_page_template.dart';
import 'package:brew_it/presentation/contract/commercial_offers/commercial_offers_page.dart';
import 'package:brew_it/presentation/contract/reservations/reservations_page.dart';

class ReservationRequestAddPage extends AddEditPageTemplate {
  ReservationRequestAddPage(Map elementData, {super.key})
      : super(
            title: "Podsumowanie rezerwacji:",
            apiCall: "/reservation-requests/",
            apiCallType: "post",
            navigateToPageSave: () {
              return ReservationsPage();
            },
            navigateToSaveIsTablePage: true,
            navigateToPageCancel: () {
              return CommercialOffersPage();
            },
            navigateToCancelIsTablePage: true,
            fieldNames: ReservationRequestsFieldNames().fieldNames,
            jsonFieldNames: ReservationRequestsFieldNames().jsonFieldNames,
            fieldEditable: [false, false, false, true, false, false, true],
            elementData: elementData);
}
