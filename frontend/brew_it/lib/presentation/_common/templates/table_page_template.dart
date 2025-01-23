import 'package:brew_it/injection_container.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_app_bar.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/contract/commercial_offers/commercial_offers_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TablePageTemplate extends StatefulWidget {
  const TablePageTemplate(
      {required this.title,
      this.buttons,
      required this.headers,
      this.options,
      this.apiString,
      this.jsonFields,
      this.passedElements,
      this.fetchDisplay,
      this.hideFirstField = false,
      this.linkedFields = const {},
        this.dateFields = const [],
      this.filtersPanel,
      super.key});

  final String title;
  final List<MainButton>? buttons;
  final List<String> headers;
  final List<MyIconButton>? options;
  final String? apiString;
  final List<String>? jsonFields;
  final List? passedElements;
  final List<Map<String, String>>? fetchDisplay;
  final bool hideFirstField;
  final Map<String, Function(Map elementData)>? linkedFields;
  final List<String>? dateFields;
  final FiltersPanel? filtersPanel;

  @override
  State<TablePageTemplate> createState() => _TablePageTemplateState();
}

class _TablePageTemplateState extends State<TablePageTemplate> {
  List elements = [];
  Map<String, Map<String, String>> fetchedFieldValues = {};

  @override
  void initState() {
    super.initState();
    if (widget.passedElements != null) {
      setState(() {
        elements = widget.passedElements!;
      });
    } else if (widget.apiString != null && widget.apiString != "") {
      fetchData();
    }
    fetchFieldValues();
  }

  Future<void> fetchData() async {
    try {
      final response = await getIt<Dio>().get(widget.apiString!);

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          elements = data;
        });
      } else {
        print("An error occured");
      }
    } on DioException catch (e) {
      print("An error occured");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttonWidgets = [];
    if (widget.buttons != null) {
      buttonWidgets.addAll(widget.buttons!);
    }

    final hasOperationsColumn = widget.headers.contains("Operacje");

    return Scaffold(
      appBar: MyAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
                // Nagłówek strony
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                        Text(widget.title,
                            style: Theme.of(context).textTheme.titleSmall),
                        const Spacer(),
                      ] +
                      buttonWidgets,
                ),
                const SizedBox(height: 16),
              ] +
              (widget.filtersPanel != null
                  ? [widget.filtersPanel!, const SizedBox(height: 30)]
                  : [Container()]) +
              [
                // Nagłówki tabeli
                Row(
                  children: [
                    ...widget.headers.skip(widget.hideFirstField ? 1 : 0).map(
                          (header) => Expanded(
                            flex: 6,
                            child: Text(
                              header,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                  ],
                ),
                const Divider(),
                // Tabela z danymi
                elements.isEmpty
                    ? Text("Brak elementów do wyświelenia",
                        style: Theme.of(context).textTheme.titleSmall)
                    : Container(),
                Expanded(
                  child: ListView.separated(
                    itemCount: elements.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final element = elements[index];
                      List<Widget> fieldValues = [];

                      // Generowanie wartości pól
                      if (widget.jsonFields != null) {
                        fieldValues = widget.jsonFields!
                            .skip(widget.hideFirstField ? 1 : 0)
                            .map((field) {
                          final isLinkedField =
                              widget.linkedFields!.containsKey(field);
                          final value = element[field]?.toString() ?? '';
                          final displayValue = fetchedFieldValues
                                      .containsKey(field) &&
                                  fetchedFieldValues[field]!.containsKey(value)
                              ? fetchedFieldValues[field]![value]!
                              : value;
                          final isDateField =
                          widget.dateFields!.contains(field);

                          bool isBooleanField = ((value == "true") ||
                                  (value == "false"))
                              ? true
                              : false;
                          Widget fieldWidget;

                          if (isBooleanField) {
                            // Render as a checkbox or empty box
                            final boolValue =
                                value.toLowerCase() == "true";
                            fieldWidget = Icon(
                              boolValue
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: boolValue ? Colors.green : Colors.grey,
                            );
                          } else if (isLinkedField) {
                            // Render as a clickable link
                            fieldWidget = GestureDetector(
                              onTap: () async {
                                final navigateToPage =
                                    widget.linkedFields?[field];
                                if (navigateToPage != null) {
                                  await fetchAndNavigate(
                                    field == "reservation_id"
                                        ? "/reservations"
                                        : "/${field}s",
                                    value,
                                    context,
                                    (data) => navigateToPage(data),
                                  );
                                }
                              },
                              child: const Text(
                                "szczegóły",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            );

                          } else if (isDateField ){
                            final formattedValue = _formatDateForDisplay(value);
                            fieldWidget = Text(
                              formattedValue,
                              textAlign: TextAlign.center,
                            );

                          } else {
                            // Render as plain text
                            fieldWidget = Text(
                              value,
                              textAlign: TextAlign.center,
                            );
                          }
                          return Expanded(
                            flex: 6,
                            child: fieldWidget,
                          );
                        }).toList();
                      }
                      // Obsługa kolumny "Operacje"
                      Widget? operationButtons;
                      if (hasOperationsColumn && widget.options != null) {
                        operationButtons = Expanded(
                          flex: 6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: widget.options!.map((optionButton) {
                              return MyIconButton(
                                type: optionButton.type,
                                navigateToPage: optionButton.navigateToPage,
                                dataForPage: element,
                                customOnPressed: optionButton.customOnPressed,
                                apiCall: optionButton.apiCall,
                                apiCallType: optionButton.apiCallType,
                                apiIdName: optionButton.apiIdName,
                                elementId: widget.headers.contains("Id")
                                    ? element[widget.jsonFields![
                                        widget.headers.indexOf("Id")]]
                                    : 0,
                                filtersData: optionButton.filtersData,
                              );
                            }).toList(),
                          ),
                        );
                      }

                      // Zwracanie pełnego wiersza tabeli
                      return Row(
                        children: [
                          ...fieldValues,
                          if (hasOperationsColumn)
                            operationButtons ?? const SizedBox(),
                        ],
                      );
                    },
                  ),
                ),
              ],
        ),
      ),
    );
  }

  bool _isIso8601Date(String value) {
    try {
      DateTime.parse(value);
      return true;
    } catch (_) {
      return false;
    }
  }

  String _formatDateForDisplay(String isoDate) {
    try {
      final parsedDate = DateTime.parse(isoDate);
      return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
    } catch (_) {
      return isoDate; // Return the original value if parsing fails
    }
  }

  Future<void> fetchFieldValues() async {
    if (widget.fetchDisplay == null) return;

    for (final fieldConfig in widget.fetchDisplay!) {
      try {
        final response = await getIt<Dio>().get(fieldConfig["endpoint"]!);

        if (response.statusCode == 200) {
          final data = response.data as List;

          // Map IDs to display values
          final fieldValues = {
            for (var item in data)
              item[fieldConfig["idField"]!].toString():
                  item[fieldConfig["displayField"]!].toString(),
          };

          setState(() {
            fetchedFieldValues[fieldConfig["fieldKey"]!] = fieldValues;
          });
        }
      } catch (e) {
        print('Error fetching ${fieldConfig["fieldKey"]} values: $e');
      }
    }
  }

  Future<void> fetchAndNavigate(
      String endpoint,
      String id,
      BuildContext context,
      Function(Map<String, dynamic>) navigateToPage) async {
    try {
      final response = await getIt<Dio>().get("$endpoint/$id");

      if (response.statusCode == 200) {
        final data = response.data;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => navigateToPage(data),
          ),
        );
      } else {
        print("Failed to fetch data from $endpoint/$id");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
}
