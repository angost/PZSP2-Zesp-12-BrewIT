import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/table_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/contract/reservation_requests/reservation_request_details_page.dart';

class ReservationRequestsPage extends TablePageTemplate {
  ReservationRequestsPage({super.key})
      : super(
            title: "Prośby o rezerwację:",
            headers: ReservationRequestsContractFieldNames().fieldNamesTable,
            options: [
              MyIconButton(
                type: "info",
                navigateToPage: (Map elementData) {
                  return ReservationRequestDetailsPage(elementData);
                },
              ),
            ],
            apiString: "/reservation-requests/",
            fetchDisplay: [
              {
                "fieldKey": "production_brewery",
                "endpoint": "/breweries/",
                "idField": "brewery_id",
                "displayField": "name",
              },
            ],
            hideFirstField: true,
            jsonFields:
                ReservationRequestsContractFieldNames().jsonFieldNamesTable);
}
