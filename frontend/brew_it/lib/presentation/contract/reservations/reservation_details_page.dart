import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/reservation_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/contract/reservations/reservations_page.dart';

class ReservationDetailsPage extends ReservationTemplate {
  ReservationDetailsPage(Map elementData, {super.key})
      : super(
            title: "Rezerwacja - szczegóły:",
            buttons: [
              MainButton(
                "Powrót",
                type: "primary_small",
                pop: true,
              )
            ],
            fieldNames: ReservationsContractFieldNames().fieldNames,
            jsonFieldNames: ReservationsContractFieldNames().jsonFieldNames,
            fieldTypes: ReservationsContractFieldNames().fieldTypes,
            fetchDisplay: [
              {
                'endpoint': '/breweries/',
                'fieldKey': 'production_brewery',
                'apiValue': elementData['production_brewery']!.toString(),
                'displayField': 'name',
              }
            ],
            elementData: elementData);
}
