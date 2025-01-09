import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/details_add_edit_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/commercial/reservations/reservations_page.dart';

class ReservationDetailsPage extends DetailsAddEditPageTemplate {
  ReservationDetailsPage(Map elementData, {super.key})
      : super(
            title: "Rezerwacja - szczegóły:",
            buttons: [
              MainButton(
                "Powrót",
                type: "primary_small",
                navigateToPage: () {
                  return ReservationsPage();
                },
              )
            ],
            options: [
              MyIconButton(
                type: "delete",
                apiCall: "/reservations/",
                apiCallType: "delete",
                elementId: elementData["reservation_id"],
                navigateToPage: () {
                  return ReservationsPage();
                },
              ),
            ],
            fieldNames: ReservationsCommercialFieldNames().fieldNames,
            jsonFieldNames: ReservationsCommercialFieldNames().jsonFieldNames,
            elementData: elementData);
}
