import 'package:brew_it/presentation/_common/widgets/menu_button.dart';
import 'package:brew_it/presentation/_common/templates/home_page_template.dart';
import 'package:brew_it/presentation/admin/registration_requests_page.dart';
import 'package:brew_it/presentation/admin/statistics_page.dart';

class HomePageAdmin extends HomePageTemplate {
  HomePageAdmin({super.key})
      : super(title: "Panel administratora", buttons: [
          MenuButton(
            "Prośby o rejestrację",
            type: "important",
            navigateToPage: RegistrationRequestsPage(),
          ),
          MenuButton(
            "Statystyki",
            navigateToPage: StatisticsPage(),
          ),
          MenuButton(
            "Wyloguj się",
            type: "warning",
          ),
        ]);
}
