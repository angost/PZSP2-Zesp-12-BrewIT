import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/add_edit_page_template.dart';
import 'package:brew_it/presentation/commercial/sectors/sector_details_page.dart';

class SectorEditPage extends AddEditPageTemplate {
  SectorEditPage(Map elementData, {super.key})
      : super(
            title: "Sektor - edytuj:",
            apiCall: "/sector/" + elementData["sector_id"].toString() + "/",
            apiCallType: "put",
            navigateToPageSave: (Map elementData) {
              return SectorDetailsPage(elementData);
            },
            navigateToPageCancel: (Map elementData) {
              return SectorDetailsPage(elementData);
            },
            fieldNames: SectorsFieldNames().fieldNames,
            jsonFieldNames: SectorsFieldNames().jsonFieldNames,
            fieldEditable: [true, true],
            elementData: elementData);
}
