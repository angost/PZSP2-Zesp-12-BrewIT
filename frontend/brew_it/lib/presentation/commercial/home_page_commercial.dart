import 'package:brew_it/presentation/commercial/allowed_people_page.dart';
import 'package:brew_it/presentation/commercial/machines/machines_page.dart';
import 'package:brew_it/presentation/_common/widgets/menu_button.dart';
import 'package:brew_it/presentation/_common/templates/home_page_template.dart';
import 'package:brew_it/presentation/commercial/reservation_requests_page.dart';
import 'package:brew_it/presentation/commercial/reservations_page.dart';
import 'package:brew_it/presentation/log_in_register/choose_user_type_page.dart';
import 'package:brew_it/presentation/log_in_register/log_in_page.dart';

class HomePageCommercial extends HomePageTemplate {
  HomePageCommercial({super.key})
      : super(
            title: "Twoje konto - Browar komercyjny - Browar Wierzbowice",
            buttons: [
              MenuButton("Zarządzanie urządzeniami",
                  type: "important", navigateToPage: MachinesPage()),
              MenuButton(
                "Twoje rezerwacje",
                navigateToPage: ReservationsPage(),
              ),
              MenuButton("Prośby o rezerwację od browarów kontraktowych",
                  navigateToPage: ReservationRequestsPage()),
              MenuButton(
                "Uprawnieni do wstępu do browaru",
                navigateToPage: AllowedPeoplePage(),
              ),
              MenuButton(
                "Wyloguj się",
                type: "warning",
                navigateToPage: const LogInPage(),
              ),
            ]);
}
