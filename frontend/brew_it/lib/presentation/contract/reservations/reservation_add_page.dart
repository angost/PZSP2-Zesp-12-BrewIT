import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/add_edit_page_template.dart';
import 'package:brew_it/presentation/contract/commercial_offers_page.dart';
import 'package:brew_it/presentation/contract/reservations/reservation_details_page.dart';

class ReservationAddPage extends AddEditPageTemplate {
  ReservationAddPage(Map elementData, {super.key})
      : super(
            title: "Podsumowanie rezerwacji:",
            apiCall: "/reservation/",
            apiCallType: "post",
            navigateToPageSave: (Map elementData) {
              return ReservationDetailsPage(elementData);
            },
            navigateToPageCancel: () {
              return CommercialOffersPage();
            },
            fieldNames: ReservationsFieldNames().fieldNames,
            jsonFieldNames: ReservationsFieldNames().jsonFieldNames,
            fieldEditable: [false, false, false, false, true, true, false],
            elementData: elementData);
}
