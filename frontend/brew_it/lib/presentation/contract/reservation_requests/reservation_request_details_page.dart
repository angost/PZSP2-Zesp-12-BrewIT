import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/details_add_edit_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/contract/reservation_requests/reservation_requests_page.dart';

import 'package:brew_it/presentation/_common/templates/reservation_template.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';

class ReservationRequestDetailsPage extends ReservationTemplate {
  ReservationRequestDetailsPage(Map elementData, {super.key})
      : super(
      title: "Prośba o rezerwację - szczegóły:",
      buttons: [
        MainButton(
          "Powrót",
          type: "primary_small",
          pop: true,
        )
      ],
      options: [
        MyIconButton(
          type: "accept",
          apiCall: "/reservations/",
          apiCallType: "post",
          apiIdName: "reservation_request_id",
          elementId: elementData["id"],
          navigateToPage: () {
            return ReservationRequestsPage();
          },
        ),
        MyIconButton(
          type: "cancel",
          apiCall: "/reservation-requests/",
          apiCallType: "delete",
          elementId: elementData["id"],
          navigateToPage: () {
            return ReservationRequestsPage();
          },
        ),
      ],
      fieldNames: ReservationRequestsContractFieldNames().fieldNames,
      jsonFieldNames: ReservationRequestsContractFieldNames().jsonFieldNames,
      fieldTypes: ReservationRequestsContractFieldNames().fieldTypes,
      fetchDisplay: [
        {
          'endpoint': '/breweries/',
          'fieldKey': 'commercial_brewery',
          'apiValue': elementData['contract_brewery']!.toString(),
          'displayField': 'name',
        }
      ],
      elementData: elementData);
}
