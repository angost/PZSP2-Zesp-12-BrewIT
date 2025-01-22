import 'package:flutter/material.dart';
import 'package:brew_it/core/theme/text_form_field_themes.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final String jsonFieldName;
  final String initialValue;
  final bool editable;
  final void Function(String?) onSaved;
  final InputDecoration? decoration;

  const DatePickerField({
    required this.label,
    required this.jsonFieldName,
    required this.initialValue,
    required this.editable,
    required this.onSaved,
    this.decoration,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure initialValue is formatted for display
    final String formattedInitialValue = (() {
      try {
        return parseDate(initialValue);
      } catch (_) {
        // If parsing fails, return initialValue unchanged
        return initialValue;
      }
    })();

    final TextEditingController controller =
    TextEditingController(text: formattedInitialValue);

    return TextFormField(
      controller: controller,
      decoration: decoration ??
          InputDecoration(
            labelText: label,
            border: editable ? null : disabledTextFormFieldTheme.border,
            fillColor: editable ? null : disabledTextFormFieldTheme.fillColor,
          ),
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
          String formattedDateForApi =
              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
          String formattedDateForDisplay =
              "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
          controller.text = formattedDateForDisplay;
          onSaved(formattedDateForApi);
        }
      },
    );
  }

  String parseDate(String date) {
    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        final year = parts[0];
        final month = parts[1];
        final day = parts[2];
        return "$day/$month/$year";
      }
      return date; // Return unchanged if not in the expected format
    } catch (_) {
      return date; // Return unchanged in case of any error
    }
  }
}

class BooleanField extends StatelessWidget {
  final String label;
  final String jsonFieldName;
  final bool value;
  final bool editable;
  final void Function(bool?) onChanged;
  final InputDecoration? decoration;

  const BooleanField({
    required this.label,
    required this.jsonFieldName,
    required this.value,
    required this.editable,
    required this.onChanged,
    this.decoration,
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
  final InputDecoration? decoration;

  const EnumField({
    required this.label,
    required this.jsonFieldName,
    required this.options,
    required this.selectedValue,
    required this.editable,
    required this.onChanged,
    this.decoration,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure selectedValue matches an option or is null
    final currentValue = options.any((option) => option['apiValue'] == selectedValue)
        ? selectedValue
        : null;

    return DropdownButtonFormField<String>(
      decoration: decoration ?? InputDecoration(
        labelText: label,
        border: editable
            ? null
            : disabledTextFormFieldTheme.border,
        fillColor: editable
            ? null
            : disabledTextFormFieldTheme.fillColor,
      ),
      value: currentValue,
      items: options.isNotEmpty
          ? options.map((option) {
        return DropdownMenuItem<String>(
          value: option['apiValue'],
          child: Text(option['display']!),
        );
      }).toList()
          : [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('No options available'),
        ),
      ],
      onChanged: editable
          ? (newValue) {
        // When an option is selected, pass the API value (not the display value)
        onChanged(newValue);
      }
          : null,
    );
  }
}

class MultiEnumField extends StatelessWidget {
  final String label;
  final String jsonFieldName;
  final List<Map<String, String>> options;
  final List<String> selectedValues;
  final bool editable;
  final void Function(List<String>) onChanged;
  final InputDecoration? decoration;

  const MultiEnumField({
    required this.label,
    required this.jsonFieldName,
    required this.options,
    required this.selectedValues,
    required this.editable,
    required this.onChanged,
    this.decoration,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter selected values to ensure they match available options
    final currentValues = selectedValues
        .where((value) => options.any((option) => option['apiValue'] == value))
        .toList();

    return FormField<List<String>>(
      initialValue: currentValues,
      builder: (FormFieldState<List<String>> field) {
        return InputDecorator(
          decoration: decoration ?? InputDecoration(
            labelText: label,
            border: editable
                ? null
                : disabledTextFormFieldTheme.border,
            fillColor: editable
                ? null
                : disabledTextFormFieldTheme.fillColor,
          ),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              ...options.map((option) {
                final isSelected = currentValues.contains(option['apiValue']);
                return FilterChip(
                  label: Text(option['display']!),
                  selected: isSelected,
                  onSelected: editable
                      ? (bool selected) {
                    List<String> newValues = List.from(currentValues);
                    if (selected) {
                      newValues.add(option['apiValue']!);
                    } else {
                      newValues.remove(option['apiValue']);
                    }
                    onChanged(newValues);
                  }
                      : null,
                );
              }).toList(),
              if (options.isEmpty)
                const Chip(
                  label: Text('No options available'),
                ),
            ],
          ),
        );
      },
    );
  }
}

class DisplayField extends StatelessWidget {
  final String label;
  final String displayValue;
  final String formValue;
  final InputDecoration? decoration;

  const DisplayField({
    required this.label,
    required this.displayValue,
    required this.formValue,
    this.decoration,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
    TextEditingController(text: displayValue);

    return TextFormField(
      controller: controller,
      decoration: decoration ??
          InputDecoration(
            labelText: label,
            border: disabledTextFormFieldTheme.border, // Mimics the DatePickerField
            fillColor: disabledTextFormFieldTheme.fillColor, // Background color for read-only
          ),
      readOnly: true,
      enabled: false, // Prevents user interaction
      style: Theme.of(context).textTheme.bodyMedium, // Styling the text
    );
  }
}

class LargeTextField extends StatefulWidget {
  final String label;
  final String initialValue;
  final bool editable;
  final InputDecoration? decoration;
  final ValueChanged<String>? onSaved;

  const LargeTextField({
    required this.label,
    required this.initialValue,
    this.editable = true,
    this.decoration,
    this.onSaved,
    Key? key,
  }) : super(key: key);

  @override
  LargeTextFieldState createState() => LargeTextFieldState();
}

class LargeTextFieldState extends State<LargeTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final updatedText = await _showTextDialog(
              context,
              _controller.text,
              widget.label,
            );
            if (updatedText != null) {
              setState(() {
                _controller.text = updatedText;
              });
              if (widget.onSaved != null) {
                widget.onSaved!(updatedText);
              }
            }
          },
          child: AbsorbPointer(
            absorbing: true, // Prevent manual typing; use dialog for editing
            child: TextFormField(
              controller: _controller,
              maxLines: 4,
              decoration: widget.decoration ??
                  InputDecoration(
                    border: widget.editable
                        ? OutlineInputBorder()
                        : InputBorder.none,
                    fillColor: widget.editable ? null : Colors.grey[200],
                    filled: !widget.editable,
                  ),
              readOnly: true,
            ),
          ),
        ),
      ],
    );
  }

  Future<String?> _showTextDialog(
      BuildContext context, String currentValue, String title) async {
    TextEditingController dialogController =
    TextEditingController(text: currentValue);

    return await showDialog<String>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5, // 80% of the screen width
            height: MediaQuery.of(context).size.height * 0.35, // 60% of the screen height
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    title,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: dialogController,
                      maxLines: null, // Allow unlimited lines
                      expands: true, // Ensures the TextField fills the space
                      textAlignVertical: TextAlignVertical.top,
                      readOnly: !widget.editable,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Wprowadź treść...",
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(null);
                        },
                        child: const Text("Anuluj"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(dialogController.text);
                        },
                        child: const Text("Zapisz"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}