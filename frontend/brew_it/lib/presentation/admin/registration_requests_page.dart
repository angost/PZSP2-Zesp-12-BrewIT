import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/table_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';

class RegistrationRequestsPage extends TablePageTemplate {
  RegistrationRequestsPage({super.key})
      : super(
          title: "Prośby o rejestrację:",
          headers: RegistrationRequestsFieldNames().fieldNamesTable,
          options: [
            MyIconButton(
              type: "accept",
              apiCall: "/registration-requests/accept/",
              apiCallType: "post",
              apiIdName: "registration_request_id",
              navigateToPage: () {
                return RegistrationRequestsPage();
              },
            ),
            MyIconButton(
              type: "cancel",
              apiCall: "/registration-requests/",
              apiCallType: "delete",
              navigateToPage: () {
                return RegistrationRequestsPage();
              },
            ),
          ],
          apiString: "/registration-requests/",
          jsonFields: RegistrationRequestsFieldNames().jsonFieldNamesTable,
        );
}
