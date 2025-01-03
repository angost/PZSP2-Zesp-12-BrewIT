import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/add_edit_page_template.dart';
import 'package:brew_it/presentation/contract/recipes/recipe_details_page.dart';

class RecipeEditPage extends AddEditPageTemplate {
  RecipeEditPage(Map elementData, {super.key})
      : super(
            title: "Receptura - edytuj:",
            apiCall: "/recipes/" + elementData["recipe_id"].toString() + "/",
            apiCallType: "put",
            navigateToPageSave: (Map elementData) {
              return RecipeDetailsPage(elementData);
            },
            navigateToPageCancel: (Map elementData) {
              return RecipeDetailsPage(elementData);
            },
            fieldNames: RecipesFieldNames().fieldNames,
            jsonFieldNames: RecipesFieldNames().jsonFieldNames,
            fieldEditable: [true, false, true],
            elementData: elementData);
}
