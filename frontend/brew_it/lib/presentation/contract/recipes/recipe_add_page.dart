import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/add_edit_page_template.dart';
import 'package:brew_it/presentation/contract/recipes/recipe_details_page.dart';
import 'package:brew_it/presentation/contract/recipes/recipes_page.dart';

class RecipeAddPage extends AddEditPageTemplate {
  RecipeAddPage(Map elementData, {super.key})
      : super(
            title: "Dodaj nową recepturę:",
            apiCall: "/recipes/",
            apiCallType: "post",
            navigateToPageSave: (Map elementData) {
              return RecipeDetailsPage(elementData);
            },
            navigateToPageCancel: () {
              return RecipesPage();
            },
            fieldNames: RecipesFieldNames().fieldNames,
            jsonFieldNames: RecipesFieldNames().jsonFieldNames,
            fieldEditable: [true, true, true],
            elementData: elementData);
}
