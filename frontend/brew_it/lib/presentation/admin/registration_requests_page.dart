import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/table_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';

class RegistrationRequestsPage extends TablePageTemplate {
  RegistrationRequestsPage({super.key})
      : super(
            title: "Prośby o rejestrację:",
            headers: RegistrationRequestsFieldNames().fieldNamesTable,
            options: [
              MyIconButton(type: "accept"),
              MyIconButton(type: "cancel"),
            ],
            // MOCK - check names used in api
            apiString: "/registration_requests/",
            jsonFields: RegistrationRequestsFieldNames().jsonFieldNamesTable);
}
