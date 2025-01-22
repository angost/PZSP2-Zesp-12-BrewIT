import 'package:brew_it/core/theme/text_form_field_themes.dart';
import 'package:brew_it/core/theme/text_themes.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_app_bar.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/_common/widgets/form_fields.dart';
import 'package:brew_it/injection_container.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DetailsAddEditPageTemplate extends StatefulWidget {
  DetailsAddEditPageTemplate(
      {required this.title,
      this.buttons,
      this.options,
      required this.fieldNames,
      required this.jsonFieldNames,
      this.fieldEditable,
      this.fieldTypes,
      this.elementData,
      this.enumOptions,
      this.fetchOptions,
      this.fetchDisplay,
      this.displayValues,
      super.key});

  final String title;
  final List<MainButton>? buttons;
  final List<MyIconButton>? options;
  final List<String> fieldNames;
  final List<String> jsonFieldNames;
  final List<bool>? fieldEditable;
  final List<String>? fieldTypes;
  Map<String, List<Map<String, String>>>? enumOptions;
  final List<Map<String, String>>? fetchOptions;
  final List<Map<String, String>>? fetchDisplay;
  Map<String, String>? displayValues;
  Map? elementData;

  @override
  State<DetailsAddEditPageTemplate> createState() =>
      _DetailsAddEditPageTemplateState();
}

class _DetailsAddEditPageTemplateState
    extends State<DetailsAddEditPageTemplate> {
  late Map<dynamic, dynamic> elementData;

  @override
  void initState() {
    super.initState();
    widget.enumOptions ??= {};
    widget.displayValues ??= {};
    if (widget.fetchOptions != null) {
      for (Map<String, String> fetchMap in widget.fetchOptions!) {
        fetchObjectOptions(fetchMap);
      }
    }
    if (widget.fetchDisplay != null) {
      for (Map<String, String> fetchMap in widget.fetchDisplay!) {
        fetchFieldDisplayValue(config: fetchMap);
      }
    }
    elementData = widget.elementData ?? {};
  }

  @override
  Widget build(BuildContext context) {
    List<String>? fieldValues;
    GlobalKey<FormState>? formKey;

    if (widget.elementData != null && widget.elementData!.isNotEmpty) {
      fieldValues = List.generate(
          widget.jsonFieldNames.length,
          (index) => widget.elementData![widget.jsonFieldNames[index]] != null
              ? widget.elementData![widget.jsonFieldNames[index]].toString()
              : "");
    }

    if (widget.buttons != null) {
      for (MainButton button in widget.buttons!) {
        if (button.formKey != null) {
          formKey = button.formKey;
          break;
        }
      }
    }

    final fieldsWidgets = generateFieldsWidgets(fieldValues);
    final splitIndex = (fieldsWidgets.length / 2).round();

    return Scaffold(
        appBar: MyAppBar(context),
        body: Padding(
          padding: const EdgeInsets.all(50),
          child: Stack(
            children: [
              Row(
                children: [
                  const Spacer(),
                  Column(
                    children: <Widget>[] +
                        (widget.buttons ?? []) +
                        [
                          Row(
                            children: widget.options ?? [],
                          ),
                          const Spacer()
                        ],
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(widget.title,
                            style: Theme.of(context).textTheme.titleSmall),
                        const Spacer(),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 8,
                      child: Form(
                          key: formKey,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children:
                                      fieldsWidgets.sublist(0, splitIndex),
                                ),
                              ),
                              const SizedBox(
                                width: 100,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: fieldsWidgets.sublist(
                                      splitIndex, fieldsWidgets.length),
                                ),
                              ),
                            ],
                          )))
                ],
              ),
            ],
          ),
        ));
  }

  List<Widget> generateFieldsWidgets(List<String>? fieldValues) {
    return List.generate(widget.fieldNames.length, (index) {
      bool editable =
          widget.fieldEditable != null && widget.fieldEditable![index];
      String fieldType =
          widget.fieldTypes != null ? widget.fieldTypes![index] : "TextField";
      String jsonFieldName = widget.jsonFieldNames[index];

      switch (fieldType) {
        case "DatePickerField":
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: DatePickerField(
                label: widget.fieldNames[index],
                jsonFieldName: jsonFieldName,
                initialValue:
                    fieldValues != null && fieldValues[index].isNotEmpty
                        ? fieldValues[index]
                        : "",
                editable: editable,
                onSaved: (newValue) {
                  if (editable) {
                    widget.elementData ??= {};
                    widget.elementData![jsonFieldName] = newValue;
                  }
                },
              ));
        case "EnumField":
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: EnumField(
              label: widget.fieldNames[index],
              jsonFieldName: jsonFieldName,
              options: widget.enumOptions?[jsonFieldName] ?? [],
              selectedValue: fieldValues != null ? fieldValues[index] : "",
              editable: editable,
              onChanged: (newValue) {
                if (editable) {
                  widget.elementData ??= {};
                  widget.elementData![jsonFieldName] = newValue;
                }
              },
            ),
          );
        case "BooleanField":
          widget.elementData![jsonFieldName] =
              fieldValues != null ? (fieldValues[index]) : "false";
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: BooleanField(
              label: widget.fieldNames[index],
              jsonFieldName: jsonFieldName,
              value: fieldValues != null
                  ? (fieldValues[index] == "true") // Convert to boolean
                  : false,
              editable: editable,
              onChanged: (newValue) {
                if (editable) {
                  widget.elementData ??= {};
                  widget.elementData![jsonFieldName] = newValue.toString();
                  fieldValues != null
                      ? fieldValues[index] = newValue.toString()
                      : false; // Update fieldValues
                  setState(() {}); // Trigger rebuild
                }
              },
            ),
          );
        case "DisplayField":
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: DisplayField(
              label: widget.fieldNames[index],
              displayValue: widget.displayValues?[jsonFieldName] ?? "",
              formValue: fieldValues != null ? fieldValues[index] : "",
            ),
          );

        case "LargeTextField":
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: LargeTextField(
              label: widget.fieldNames[index],
              initialValue:
              fieldValues != null && fieldValues[index].isNotEmpty
              ? fieldValues[index]
                  : "",
              editable: editable,
              onSaved: (newValue) {
                if (editable) {
                  widget.elementData ??= {};
                  widget.elementData![jsonFieldName] = newValue;
                }
              },
              decoration: InputDecoration(
              labelText: widget.fieldNames[index],
              border: editable ? null : disabledTextFormFieldTheme.border,
              fillColor:
              editable ? null : disabledTextFormFieldTheme.fillColor,
            ),
            ),
          );

        default: // TextField
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              onSaved: (newValue) {
                if (editable) {
                  widget.elementData ??= {};
                  widget.elementData![jsonFieldName] = newValue;
                }
              },
              decoration: InputDecoration(
                labelText: widget.fieldNames[index],
                border: editable ? null : disabledTextFormFieldTheme.border,
                fillColor:
                    editable ? null : disabledTextFormFieldTheme.fillColor,
              ),
              initialValue: fieldValues != null ? fieldValues[index] : "",
              enabled: editable,
              style: baseTextTheme.bodyLarge,
            ),
          );
      }
    });
  }

  Future<void> fetchObjectOptions(Map<String, String> config) async {
    try {
      final response = await getIt<Dio>().get(config['endpoint']!);
      if (response.statusCode == 200) {
        final options = (response.data as List)
            .map((item) => {
                  "display": item[config['displayField']!].toString(),
                  "apiValue": item[config['apiValueField']!].toString(),
                })
            .toList();
        setState(() {
          widget.enumOptions?[config['enumKey']!] = options;
        });
      }
    } catch (e) {
      print(
          'Error fetching ${config['enumKey']} options from ${config['endpoint']}: $e');
    }
  }

  Future<void> fetchFieldDisplayValue(
      {required Map<String, String> config}) async {
    String endpoint = config['endpoint']!;
    String fieldKey = config['fieldKey']!;
    String apiValue = config['apiValue']!;
    String displayField = config['displayField']!;
    try {
      // Construct the API endpoint with the brewery ID
      final response = await getIt<Dio>().get('$endpoint/$apiValue');
      if (response.statusCode == 200) {
        // Extract the display field value
        final displayValue = response.data[displayField];
        if (displayValue != null) {
          setState(() {
            widget.displayValues?[fieldKey] = displayValue.toString();
          });
        } else {
          print("Display field '$displayField' not found in response data.");
        }
      } else {
        print(
            'Failed to fetch display value for $fieldKey. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching display value for $fieldKey: $e');
    }
  }
}
