import 'package:brew_it/presentation/_common/widgets/menu_button.dart';
import 'package:brew_it/presentation/_common/templates/home_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/menu_logout_button.dart';
import 'package:brew_it/presentation/admin/registration_requests_page.dart';
import 'package:brew_it/presentation/admin/statistics/statistics_page.dart';

class HomePageAdmin extends HomePageTemplate {
  HomePageAdmin({super.key})
      : super(title: "Panel administratora", buttons: [
          MenuButton(
            type: "registration_requests",
            navigateToPage: RegistrationRequestsPage(),
          ),
          MenuButton(
            type: "stats",
            navigateToPage: StatisticsPage(),
          ),
          MenuButton(
            type: "logout",
          ),
          MenuLogoutButton(),
        ]);
}
