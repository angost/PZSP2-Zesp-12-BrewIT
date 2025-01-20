import 'package:brew_it/presentation/_common/widgets/menu_button.dart';
import 'package:brew_it/presentation/_common/templates/home_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/menu_logout_button.dart';
import 'package:brew_it/presentation/contract/commercial_offers/commercial_offers_page.dart';
import 'package:brew_it/presentation/contract/production_processes/production_processes_page.dart';
import 'package:brew_it/presentation/contract/recipes/recipes_page.dart';
import 'package:brew_it/presentation/contract/reservations/reservations_page.dart';

class HomePageContract extends HomePageTemplate {
  HomePageContract({super.key})
      : super(
            title: "Twoje konto - Browar kontraktowy - Browar Stary Kamień",
            buttons: [
              MenuButton(
                type: "commercial_offers",
                navigateToPage: CommercialOffersPage(),
              ),
              MenuButton(
                type: "reservations",
                navigateToPage: ReservationsPage(),
              ),
              MenuButton(
                type: "production_processes",
                navigateToPage: ProductionProcessesPage(),
              ),
              MenuButton(
                type: "recipes",
                navigateToPage: RecipesPage(),
              ),
              MenuButton(
                type: "logout",
              ),
              MenuLogoutButton(),
            ]);
}
