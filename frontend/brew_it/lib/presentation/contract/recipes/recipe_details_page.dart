import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/details_add_edit_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/contract/recipes/recipes_page.dart';

class RecipeDetailsPage extends DetailsAddEditPageTemplate {
  RecipeDetailsPage(Map elementData, {super.key})
      : super(
            title: "Receptura - szczegóły:",
            buttons: [
              MainButton(
                "Powrót",
                type: "primary_small",
                navigateToPage: () {
                  return RecipesPage();
                },
              )
            ],
            options: [
              // MyIconButton(
              //   type: "edit",
              //   navigateToPage: (Map elementData) {
              //     return RecipeEditPage(elementData);
              //   },
              //   dataForPage: elementData,
              // ),
              MyIconButton(
                type: "delete",
                apiCall: "/recipes/",
                apiCallType: "delete",
                elementId: elementData["recipe_id"],
                navigateToPage: () {
                  return RecipesPage();
                },
              ),
            ],
            fieldNames: RecipesFieldNames().fieldNames,
            jsonFieldNames: RecipesFieldNames().jsonFieldNames,
            fieldTypes: RecipesFieldNames().fieldTypes,
            fetchOptions: RecipesFieldNames().fetchOptions,
            elementData: elementData);
}
