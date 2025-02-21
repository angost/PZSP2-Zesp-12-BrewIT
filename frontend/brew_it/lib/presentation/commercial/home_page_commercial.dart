import 'package:brew_it/presentation/commercial/brewery_data/brewery_data_page.dart';
import 'package:brew_it/presentation/commercial/machines/machines_page.dart';
import 'package:brew_it/presentation/_common/widgets/menu_button.dart';
import 'package:brew_it/presentation/_common/templates/home_page_template.dart';
import 'package:brew_it/presentation/commercial/reservation_requests/reservation_requests_page.dart';
import 'package:brew_it/presentation/commercial/reservations/reservations_page.dart';
import 'package:brew_it/presentation/commercial/sectors/sectors_page.dart';

class HomePageCommercial extends HomePageTemplate {
  HomePageCommercial({super.key})
      : super(title: "Twoje konto - Browar komercyjny", buttons: [
          MenuButton(type: "machines", navigateToPage: MachinesPage()),
          MenuButton(type: "sectors", navigateToPage: SectorsPage()),
          MenuButton(
            type: "reservations",
            navigateToPage: ReservationsPage(),
          ),
          MenuButton(
              type: "reservation_requests",
              navigateToPage: ReservationRequestsPage()),
          // MenuButton(
          //   "Uprawnieni do wstępu do browaru",
          //   navigateToPage: AllowedPeoplePage(),
          // ),
          MenuButton(
              type: "brewery_data",
              navigateToPage: navigateToBreweryDataPage()),
          MenuButton(
            type: "logout",
          ),
        ]);
}
