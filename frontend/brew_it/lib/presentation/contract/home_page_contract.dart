import 'package:brew_it/presentation/_common/widgets/menu_button.dart';
import 'package:brew_it/presentation/_common/templates/home_page_template.dart';
import 'package:brew_it/presentation/contract/commercial_offers_page.dart';
import 'package:brew_it/presentation/contract/production_processes/production_processes_page.dart';
import 'package:brew_it/presentation/contract/recipes_page.dart';
import 'package:brew_it/presentation/contract/reservations_page.dart';
import 'package:brew_it/presentation/log_in_register/choose_user_type_page.dart';
import 'package:brew_it/presentation/log_in_register/log_in_page.dart';

class HomePageContract extends HomePageTemplate {
  HomePageContract({super.key})
      : super(
            title: "Twoje konto - Browar kontraktowy - Browar Stary Kamień",
            buttons: [
              MenuButton(
                "Oferta browarów komercyjnych",
                type: "important",
                navigateToPage: CommercialOffersPage(),
              ),
              MenuButton(
                "Twoje rezerwacje",
                navigateToPage: ReservationsPage(),
              ),
              MenuButton(
                "Procesy wykonania piwa",
                navigateToPage: ProductionProcessesPage(),
              ),
              MenuButton(
                "Twoje receptury",
                navigateToPage: RecipesPage(),
              ),
              MenuButton(
                "Wyloguj się",
                type: "warning",
                navigateToPage: const LogInPage(),
              ),
            ]);
}
