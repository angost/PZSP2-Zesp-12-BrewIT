import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/details_add_edit_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/commercial/sectors/sector_edit_page.dart';
import 'package:brew_it/presentation/commercial/sectors/sectors_page.dart';

class SectorDetailsPage extends DetailsAddEditPageTemplate {
  SectorDetailsPage(Map elementData, {super.key})
      : super(
            title: "Sektor - szczegóły:",
            buttons: [
              MainButton(
                "Powrót",
                type: "primary_small",
                navigateToPage: () {
                  return SectorsPage();
                },
              )
            ],
            options: [
              // MyIconButton(type: "link"),
              MyIconButton(
                type: "edit",
                navigateToPage: (Map elementData) {
                  return SectorEditPage(elementData);
                },
                dataForPage: elementData,
              ),
              MyIconButton(
                type: "delete",
                apiCall: "/sectors/",
                apiCallType: "delete",
                elementId: elementData["sector_id"],
                navigateToPage: () {
                  return SectorsPage();
                },
              ),
            ],
            fieldNames: SectorsFieldNames().fieldNames,
            jsonFieldNames: SectorsFieldNames().jsonFieldNames,
            elementData: elementData);
}
