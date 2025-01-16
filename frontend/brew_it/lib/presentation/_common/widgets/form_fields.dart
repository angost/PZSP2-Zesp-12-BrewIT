import 'package:flutter/material.dart';

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
    // Ensure initialValue is formatted for display
    final String formattedInitialValue = initialValue.isNotEmpty
        ? (DateTime.tryParse(initialValue) != null
        ? "${DateTime.parse(initialValue).day}/${DateTime.parse(initialValue).month}/${DateTime.parse(initialValue).year}"
        : initialValue)
        : "";

    final TextEditingController controller =
    TextEditingController(text: formattedInitialValue);

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
          // Format the date for API and display
          String formattedDateForApi = pickedDate.toIso8601String();
          String formattedDateForDisplay =
              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
          controller.text = formattedDateForDisplay;
          onSaved(formattedDateForApi);
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