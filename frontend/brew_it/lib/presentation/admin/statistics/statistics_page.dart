import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/table_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/admin/statistics/statistics_details_page.dart';
import 'package:brew_it/presentation/admin/statistics/statistics_sum_page.dart';

class StatisticsPage extends TablePageTemplate {
  StatisticsPage({super.key})
      : super(
            title: "Statystyki szczegółowe:",
            button: MainButton("Statystyki łączne", type: "secondary_small",
                navigateToPage: () {
              return StatisticsSumPage(const {
                // MOCK - implement option of fetching data from api to DetailsAddEditPageTemplate apart from passing it in constructor
                "commercial_number": 999,
                "contract_number": 999,
                "amount": 999,
                "sum_cancelled_reservations": 999,
                "sum_failed_beer": 999,
              });
            }),
            headers: StatisticsFieldNames().fieldNamesTable,
            options: [
              MyIconButton(
                type: "info",
                navigateToPage: (Map elementData) {
                  return StatisticsDetailsPage(elementData);
                },
              ),
            ],
            // MOCK - check names used in api
            apiString: "/statistics/",
            jsonFields: StatisticsFieldNames().jsonFieldNamesTable);
}
