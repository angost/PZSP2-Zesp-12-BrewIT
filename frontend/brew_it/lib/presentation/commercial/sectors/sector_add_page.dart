import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/add_edit_page_template.dart';
import 'package:brew_it/presentation/commercial/sectors/sector_details_page.dart';
import 'package:brew_it/presentation/commercial/sectors/sectors_page.dart';

class SectorAddPage extends AddEditPageTemplate {
  SectorAddPage(Map elementData, {super.key})
      : super(
            title: "Dodaj nowy sektor:",
            apiCall: "/sectors/",
            apiCallType: "post",
            navigateToPageSave: (Map elementData) {
              return SectorDetailsPage(elementData);
            },
            navigateToPageCancel: () {
              return SectorsPage();
            },
            fieldNames: SectorsFieldNames().fieldNames,
            jsonFieldNames: SectorsFieldNames().jsonFieldNames,
            fieldEditable: [true, true],
            fieldTypes: SectorsFieldNames().fieldTypes,
            errorMessages: SectorsFieldNames().errorMessages,
            elementData: elementData);
}
