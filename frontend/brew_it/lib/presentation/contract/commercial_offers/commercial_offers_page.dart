import 'package:brew_it/presentation/_common/templates/table_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';

class CommercialOffersPage extends TablePageTemplate {
  CommercialOffersPage({super.key})
      : super(
            title: "Browary spełniające warunki:",
            button: MainButton(
              "FILTRUJ",
              type: "primary_small",
            ),
            headers: [
              "Id",
              "Nazwa",
              "Liczba maszyn",
              "% Anulowanych rezerwacji",
              "% Nieudanego piwa",
              "Operacje"
            ],
            options: [
              MyIconButton(type: "configure"),
            ],
            // MOCK
            apiString: "https://jsonplaceholder.typicode.com/todos/",
            jsonFields: ["id", "title", "completed"]);
}
