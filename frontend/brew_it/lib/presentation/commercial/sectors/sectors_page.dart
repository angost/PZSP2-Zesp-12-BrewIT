import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/table_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/commercial/sectors/sector_add_page.dart';
import 'package:brew_it/presentation/commercial/sectors/sector_details_page.dart';
import 'package:brew_it/presentation/commercial/sectors/sector_edit_page.dart';

class SectorsPage extends TablePageTemplate {
  SectorsPage({super.key})
      : super(
            title: "Twoje sektory:",
            buttons: [MainButton("Dodaj sektor", type: "secondary_small",
                navigateToPage: () {
              return SectorAddPage({});
            })],
            headers: SectorsFieldNames().fieldNamesTable,
            options: [
              MyIconButton(
                type: "info",
                navigateToPage: (Map elementData) {
                  return SectorDetailsPage(elementData);
                },
              ),
              // MyIconButton(type: "link"),
              MyIconButton(
                type: "edit",
                navigateToPage: (Map elementData) {
                  return SectorEditPage(elementData);
                },
              ),
              MyIconButton(
                type: "delete",
                apiCall: "/sectors/",
                apiCallType: "delete",
                navigateToPage: () {
                  return SectorsPage();
                },
              ),
            ],
            apiString: "/sectors/",
            hideFirstField: true,
            jsonFields: SectorsFieldNames().jsonFieldNamesTable);
}
