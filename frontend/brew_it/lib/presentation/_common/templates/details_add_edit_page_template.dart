import 'package:brew_it/core/theme/text_form_field_themes.dart';
import 'package:brew_it/core/theme/text_themes.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_app_bar.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/_common/widgets/form_fields.dart';
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
        super.key});

  final String title;
  final List<MainButton>? buttons;
  final List<MyIconButton>? options;
  final List<String> fieldNames;
  final List<String> jsonFieldNames;
  final List<bool>? fieldEditable;
  final List<String>? fieldTypes;
  final Map<String, List<Map<String, String>>>? enumOptions;
  Map? elementData;

  @override
  State<DetailsAddEditPageTemplate> createState() =>
      _DetailsAddEditPageTemplateState();
}

class _DetailsAddEditPageTemplateState
    extends State<DetailsAddEditPageTemplate> {
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(widget.fieldNames.length, (index) {
                              bool editable = widget.fieldEditable != null && widget.fieldEditable![index];
                              String fieldType = widget.fieldTypes != null ? widget.fieldTypes![index] : "TextField";
                              String jsonFieldName = widget.jsonFieldNames[index];

                              switch (fieldType) {
                                case "DatePickerField":
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: DatePickerField(
                                      label: widget.fieldNames[index],
                                      jsonFieldName: jsonFieldName,
                                      initialValue: fieldValues != null && fieldValues[index].isNotEmpty
                                          ? fieldValues[index]
                                          : "",
                                      editable: editable,
                                      onSaved: (newValue) {
                                        if (editable) {
                                          widget.elementData ??= {};
                                          widget.elementData![jsonFieldName] = newValue;
                                        }
                                      },
                                    ),
                                  );
                                case "EnumField":
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: EnumField(
                                      label: widget.fieldNames[index],
                                      jsonFieldName: jsonFieldName,
                                      options: widget.enumOptions?[jsonFieldName] ?? [],
                                      selectedValue: fieldValues != null
                                          ? fieldValues[index]
                                          : "",
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
                                          fieldValues != null ? fieldValues[index] = newValue.toString() : false; // Update fieldValues
                                          setState(() {}); // Trigger rebuild
                                        }
                                      },
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
                                        border: editable
                                            ? null
                                            : disabledTextFormFieldTheme.border,
                                        fillColor: editable
                                            ? null
                                            : disabledTextFormFieldTheme.fillColor,
                                      ),
                                      initialValue: fieldValues != null
                                          ? fieldValues[index]
                                          : "",
                                      enabled: editable,
                                      style: baseTextTheme.bodyLarge,
                                    ),
                                  );
                              }
                            }),
                          ),
                      ))
                ],
              ),
            ],
          ),
        ));
  }
}
