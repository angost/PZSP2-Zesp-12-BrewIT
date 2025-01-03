import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/details_add_edit_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/admin/statistics/statistics_page.dart';

class StatisticsDetailsPage extends DetailsAddEditPageTemplate {
  StatisticsDetailsPage(Map elementData, {super.key})
      : super(
            title: "Statystyki browaru - szczegóły:",
            buttons: [
              MainButton(
                "Powrót",
                type: "primary_small",
                navigateToPage: () {
                  return StatisticsPage();
                },
              )
            ],
            fieldNames: StatisticsFieldNames().fieldNames,
            jsonFieldNames: StatisticsFieldNames().jsonFieldNames,
            elementData: elementData);
}
