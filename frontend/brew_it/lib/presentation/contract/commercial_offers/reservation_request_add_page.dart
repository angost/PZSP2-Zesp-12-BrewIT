import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/add_edit_page_template.dart';
import 'package:brew_it/presentation/contract/commercial_offers/commercial_offers_page.dart';
import 'package:brew_it/presentation/contract/reservations/reservations_page.dart';

class ReservationRequestAddPage extends ReservationRequestAddTemplate {
  ReservationRequestAddPage(Map elementData, {super.key})
      : super(
      title: "Podsumowanie rezerwacji:",
      fieldNames: AddReservationRequestFieldNames().fieldNames,
      jsonFieldNames: AddReservationRequestFieldNames().jsonFieldNames,
      fieldTypes: AddReservationRequestFieldNames().fieldTypes,
      fieldEditable: [false, false, false, false],
      elementData: elementData,
      buttons: [
        MainButton(
          text: "Save",
          onPressed: () async {
            // Your save logic here
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReservationsPage()),
            );
          },
        ),
        MainButton(
          text: "Cancel",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CommercialOffersPage()),
            );
          },
        ),
      ]);
}
