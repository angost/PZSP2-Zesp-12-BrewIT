import 'package:brew_it/injection_container.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_app_bar.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
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
      super.key});

  final String title;
  final List<MainButton>? buttons;
  final List<String> headers;
  final List<MyIconButton>? options;
  final String? apiString;
  final List<String>? jsonFields;
  final List? passedElements;
  final List<Map<String, String>>? fetchDisplay;

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
          children: [
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
            // Nagłówki tabeli
            Row(
              children: [
                ...widget.headers.map(
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
            Expanded(
              child: ListView.separated(
                itemCount: elements.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final element = elements[index];
                  List<Widget> fieldValues = [];

                  // Generowanie wartości pól
                  if (widget.jsonFields != null) {
                    fieldValues = widget.jsonFields!.map((field) {
                    fieldValues = widget.jsonFields!
                        .map((field) {
                      final value = element[field]?.toString() ?? '';

                      final displayValue = fetchedFieldValues.containsKey(field) && fetchedFieldValues[field]!.containsKey(value)
                          ? fetchedFieldValues[field]![value]!
                          : value;

                      final formattedValue = _isIso8601Date(value)
                          ? _formatDateForDisplay(value)
                          : displayValue;

                      return Expanded(
                        flex: 6,
                        child: Text(
                          formattedValue,
                          textAlign: TextAlign.center,
                        ),
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
                      if (hasOperationsColumn) operationButtons ?? const SizedBox(),
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
            for (var item in data) item[fieldConfig["idField"]!].toString(): item[fieldConfig["displayField"]!].toString(),
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



}
