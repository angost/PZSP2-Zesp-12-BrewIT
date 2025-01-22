import 'package:brew_it/core/theme/text_form_field_themes.dart';
import 'package:brew_it/core/theme/text_themes.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:brew_it/presentation/_common/widgets/form_fields.dart';

class FilterPageTemplate extends StatefulWidget {
  FilterPageTemplate({
    required this.title,
    this.buttons,
    this.formKey,
    this.options,
    required this.fieldNames,
    required this.jsonFieldNames,
    required this.fieldTypes,
    this.enumOptions,
    this.fieldEditable,
    this.elementData,
    super.key,
  });

  final String title;
  final List<MainButton>? buttons;
  GlobalKey<FormState>? formKey;
  final List<MyIconButton>? options;
  final List<String> fieldNames;
  final List<String> jsonFieldNames;
  final List<String> fieldTypes; // Added fieldTypes
  final Map<String, List<Map<String, String>>>? enumOptions; // Enum options
  final List<bool>? fieldEditable;
  Map? elementData;

  @override
  State<FilterPageTemplate> createState() => _FilterPageTemplateState();
}

class _FilterPageTemplateState extends State<FilterPageTemplate> {
  late Map<dynamic, dynamic> elementData;

  @override
  void initState() {
    super.initState();
    elementData = widget.elementData ?? {};
  }

  @override
  Widget build(BuildContext context) {
    List<String>? fieldValues;

    // Initialize field values
    if (widget.elementData != null && widget.elementData!.isNotEmpty) {
      fieldValues = List.generate(
        widget.jsonFieldNames.length,
        (index) => widget.elementData![widget.jsonFieldNames[index]] != null
            ? widget.elementData![widget.jsonFieldNames[index]].toString()
            : "",
      );
    }

    final fieldsWidgets = generateFieldsWidgets(fieldValues);
    List<Widget> fieldsWidgetsVat = [];
    List<Widget> fieldsWidgetsBrewset = [];
    List<Widget> fieldsWidgetsGeneral = [];
    int i = 0;
    while (i < fieldsWidgets.length) {
      String jsonName = widget.jsonFieldNames[i];
      if (jsonName.contains('vat')) {
        fieldsWidgetsVat.add(fieldsWidgets[i]);
      } else if (jsonName.contains('brewset')) {
        fieldsWidgetsBrewset.add(fieldsWidgets[i]);
      } else {
        fieldsWidgetsGeneral.add(fieldsWidgets[i]);
      }
      i += 1;
    }

    return Card(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Column(
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Form(
                  key: widget.formKey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                                const Text('Ogólne'),
                              ] +
                              fieldsWidgetsGeneral,
                        ),
                      ),
                      const SizedBox(
                        width: 100,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                                const Text('Zbiornik'),
                              ] +
                              fieldsWidgetsVat,
                        ),
                      ),
                      const SizedBox(
                        width: 100,
                      ),
                      Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                                  const Text('Zestaw do warzenia'),
                                ] +
                                fieldsWidgetsBrewset),
                      ),
                    ],
                  )),
            ),
          ),
          const SizedBox(height: 20),
          // Buttons Section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.buttons ?? [],
          ),
        ],
      ),
    );
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
        // case "DisplayField":
        //   return Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 8.0),
        //     child: DisplayField(
        //       label: widget.fieldNames[index],
        //       displayValue: widget.displayValues?[jsonFieldName] ?? "",
        //       formValue: fieldValues != null ? fieldValues[index] : "",
        //     ),
        //   );

        default: // TextField
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              onSaved: (newValue) {
                if (editable) {
                  widget.elementData ??= {};
                  if (newValue != null && newValue.trim().isNotEmpty) {
                    widget.elementData![jsonFieldName] = newValue.trim();
                  } else {
                    // Remove the field if the value is empty
                    widget.elementData!.remove(jsonFieldName);
                  }
                }
              },
              decoration: InputDecoration(
                labelText: widget.fieldNames[index],
                border: editable ? null : disabledTextFormFieldTheme.border,
                fillColor: editable ? null : disabledTextFormFieldTheme.fillColor,
              ),
              initialValue: fieldValues != null ? fieldValues[index] : "",
              enabled: editable,
              style: baseTextTheme.bodyLarge,
            ),
          );
      }
    });
  }
}
