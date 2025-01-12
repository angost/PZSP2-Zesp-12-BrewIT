import 'package:brew_it/core/theme/text_form_field_themes.dart';
import 'package:brew_it/core/theme/text_themes.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_app_bar.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:flutter/material.dart';

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
  State<FilterPageTemplate> createState() =>
      _DetailsAddEditPageTemplateState();
}

class _DetailsAddEditPageTemplateState
    extends State<FilterPageTemplate> {
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

    return Scaffold(
      appBar: MyAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            // Title Section
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(widget.fieldNames.length, (index) {
                      bool editable = widget.fieldEditable != null &&
                          widget.fieldEditable![index];
                      String jsonFieldName = widget.jsonFieldNames[index];
                      String fieldType = widget.fieldTypes[index];

                      // Render field based on fieldType
                      switch (fieldType) {
                        case "DatePickerField":
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: DatePickerField(
                              label: widget.fieldNames[index],
                              jsonFieldName: jsonFieldName,
                              initialValue: fieldValues != null
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
      ),
    );
  }
}


class DatePickerField extends StatelessWidget {
  final String label;
  final String jsonFieldName;
  final String initialValue;
  final bool editable;
  final void Function(String?) onSaved;

  const DatePickerField({
    required this.label,
    required this.jsonFieldName,
    required this.initialValue,
    required this.editable,
    required this.onSaved,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
    TextEditingController(text: initialValue);

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      readOnly: true,
      enabled: editable,
      onTap: () async {
        if (!editable) return;
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.tryParse(initialValue) ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          // Format the date in API-compatible format
          String formattedDate = "${pickedDate.toIso8601String()}";
          controller.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
          onSaved(formattedDate);
        }
      },
    );
  }
}

class BooleanField extends StatelessWidget {
  final String label;
  final String jsonFieldName;
  final bool value;
  final bool editable;
  final void Function(bool?) onChanged;

  const BooleanField({
    required this.label,
    required this.jsonFieldName,
    required this.value,
    required this.editable,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(
          value: value,
          onChanged: editable ? onChanged : null,
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}

class EnumField extends StatelessWidget {
  final String label;
  final String jsonFieldName;
  final List<Map<String, String>> options;
  final String selectedValue;
  final bool editable;
  final void Function(String?) onChanged;

  const EnumField({
    required this.label,
    required this.jsonFieldName,
    required this.options,
    required this.selectedValue,
    required this.editable,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      value: selectedValue.isNotEmpty ? selectedValue : null,
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option['apiValue'],
          child: Text(option['display']!),
        );
      }).toList(),
      onChanged: editable
          ? (newValue) {
        // When an option is selected, pass the API value (not the display value)
        onChanged(newValue);
      }
          : null,
    );
  }
}
