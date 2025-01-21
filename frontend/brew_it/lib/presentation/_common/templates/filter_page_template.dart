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
    GlobalKey<FormState>? formKey;

    // Initialize field values
    if (widget.elementData != null && widget.elementData!.isNotEmpty) {
      fieldValues = List.generate(
        widget.jsonFieldNames.length,
        (index) => widget.elementData![widget.jsonFieldNames[index]] != null
            ? widget.elementData![widget.jsonFieldNames[index]].toString()
            : "",
      );
    }

    // Retrieve formKey from MainButton if available
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

    return Card(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Column(
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: fieldsWidgets,
                ),
              ),
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
}
