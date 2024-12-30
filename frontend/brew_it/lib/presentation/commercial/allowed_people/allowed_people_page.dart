import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/table_page_template.dart';

class AllowedPeoplePage extends TablePageTemplate {
  // MOCK - pass date as a parameter / add date form field
  AllowedPeoplePage({super.key})
      : super(
            title: "Osoby upoważnione do wstępu:",
            headers: AllowedPeopleFieldNames().fieldNamesTable,
            // MOCK - check names used in api
            apiString: "/allowed_people/",
            jsonFields: AllowedPeopleFieldNames().jsonFieldNamesTable);
}
