import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/add_edit_page_template.dart';
import 'package:brew_it/presentation/contract/recipes/recipe_details_page.dart';
import 'package:brew_it/presentation/contract/recipes/recipes_page.dart';

class RecipeEditPage extends AddEditPageTemplate {
  RecipeEditPage(Map elementData, {super.key})
      : super(
            title: "Receptura - edytuj:",
            apiCall: "/recipes/${elementData["recipe_id"]}/",
            apiCallType: "put",
            navigateToPageSave: (Map elementData) {
              return RecipesPage();
            },
            navigateToPageCancel: (Map elementData) {
              return RecipeDetailsPage(elementData);
            },
            fieldNames: RecipesFieldNames().fieldNames,
            jsonFieldNames: RecipesFieldNames().jsonFieldNames,
            fieldEditable: [false, false, true, true, true, true, true],
            fieldTypes: RecipesFieldNames().fieldTypes,
            errorMessages: RecipesFieldNames().errorMessages,
            elementData: elementData);
}
