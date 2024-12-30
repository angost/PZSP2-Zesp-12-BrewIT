import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/table_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/contract/recipes/recipe_add_page.dart';
import 'package:brew_it/presentation/contract/recipes/recipe_details_page.dart';
import 'package:brew_it/presentation/contract/recipes/recipe_edit_page.dart';

class RecipesPage extends TablePageTemplate {
  RecipesPage({super.key})
      : super(
            title: "Twoje receptury:",
            button: MainButton("Dodaj recepturę", type: "secondary_small",
                navigateToPage: () {
              return RecipeAddPage({});
            }),
            headers: RecipesFieldNames().fieldNamesTable,
            options: [
              MyIconButton(
                type: "info",
                navigateToPage: (Map elementData) {
                  return RecipeDetailsPage(elementData);
                },
              ),
              MyIconButton(
                type: "edit",
                navigateToPage: (Map elementData) {
                  return RecipeEditPage(elementData);
                },
              ),
              MyIconButton(type: "delete")
            ],
            // MOCK - check names used in api
            apiString: "/recipes/",
            jsonFields: RecipesFieldNames().jsonFieldNamesTable);
}
