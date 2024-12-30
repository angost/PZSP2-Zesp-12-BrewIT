import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/details_add_edit_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/admin/statistics/statistics_page.dart';

class StatisticsSumPage extends DetailsAddEditPageTemplate {
  StatisticsSumPage(Map elementData, {super.key})
      : super(
            title: "Statystyki łączne:",
            buttons: [
              MainButton(
                "Statystyki szczegółowe",
                type: "secondary_small",
                navigateToPage: () {
                  return StatisticsPage();
                },
              )
            ],
            fieldNames: StatisticsSumFieldNames().fieldNames,
            jsonFieldNames: StatisticsSumFieldNames().jsonFieldNames,
            elementData: elementData);
}
