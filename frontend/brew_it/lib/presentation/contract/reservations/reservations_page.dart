import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/table_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/contract/reservations/reservation_details_page.dart';

class ReservationsPage extends TablePageTemplate {
  ReservationsPage({super.key})
      : super(
            title: "Twoje rezerwacje:",
            headers: ReservationsContractFieldNames().fieldNamesTable,
            options: [
              MyIconButton(
                type: "info",
                navigateToPage: (Map elementData) {
                  return ReservationDetailsPage(elementData);
                },
              ),
              // MyIconButton(
              //   type: "delete",
              //   apiCall: "/reservations/",
              //   apiCallType: "delete",
              //   navigateToPage: () {
              //     return ReservationsPage();
              //   },
              // ),
            ],
            apiString: "/reservations/",
            fetchDisplay: [
              {
                "fieldKey": "production_brewery",
                "endpoint": "/breweries/",
                "idField": "brewery_id",
                "displayField": "name",
              },
            ],
            hideFirstField: true,
            jsonFields: ReservationsContractFieldNames().jsonFieldNamesTable);
}
