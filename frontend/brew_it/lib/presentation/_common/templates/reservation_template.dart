import 'package:brew_it/core/theme/text_form_field_themes.dart';
import 'package:brew_it/core/theme/text_themes.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_app_bar.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/_common/widgets/form_fields.dart';
import 'package:brew_it/injection_container.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReservationTemplate extends StatefulWidget {
  ReservationTemplate({
    required this.title,
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
    super.key,
  });

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
  State<ReservationTemplate> createState() =>
      _ReservationTemplateState();
}

class _ReservationTemplateState extends State<ReservationTemplate> {
  late Map<dynamic, dynamic> elementData;
  List<Map<String, dynamic>> vatReservations = [];
  List<Map<String, dynamic>> brewsetReservations = [];
  List<Map<String, dynamic>> authorizedWorkers = [];

  @override
  void initState() {
    super.initState();
    widget.enumOptions ??= {
      'selector': [
        {'display': 'Brewing', 'apiValue': 'BREW'},
        {'display': 'Cleaning', 'apiValue': 'CLEAN'},
      ]
    };
    widget.displayValues ??= {};
    elementData = widget.elementData ?? {};

    // Initialize equipment reservations and workers
    if (elementData['equipment_reservations'] != null) {
      loadEquipmentDetails();
    } else if (elementData['equipment_reservation_requests'] != null)
      loadEquipmentDetailsReservations();

    authorizedWorkers = List<Map<String, dynamic>>.from(
        elementData['authorised_workers'] ?? []);

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
  }

  Future<void> loadEquipmentDetails() async {
    final reservations = elementData['equipment_reservations'] as List;

    for (var reservation in reservations) {
      try {
        final response = await getIt<Dio>().get('/equipment/${reservation['equipment']}');

        if (response.statusCode == 200) {
          final equipmentData = response.data;
          // Add equipment details to the reservation
          reservation['equipment_type'] = equipmentData['selector'];
          reservation['equipment_name'] = equipmentData['name'];
          reservation['equipment_capacity'] = equipmentData['capacity'].toString();

          setState(() {
            if (equipmentData['selector'] == 'VAT') {
              vatReservations.add(reservation);
            } else if (equipmentData['selector'] == 'BREWSET') {
              brewsetReservations.add(reservation);
            }
          });
        }
      } catch (e) {
        print('Error fetching equipment details for ID ${reservation['equipment']}: $e');
      }
    }
  }

  Future<void> loadEquipmentDetailsReservations() async {
    final reservations = elementData['equipment_reservation_requests'] as List;

    for (var reservation in reservations) {
      try {
        final response = await getIt<Dio>().get('/equipment/${reservation['equipment']}');

        if (response.statusCode == 200) {
          final equipmentData = response.data;
          // Add equipment details to the reservation
          reservation['equipment_type'] = equipmentData['selector'];
          reservation['equipment_name'] = equipmentData['name'];
          reservation['equipment_capacity'] = equipmentData['capacity'].toString();

          setState(() {
            if (equipmentData['selector'] == 'VAT') {
              vatReservations.add(reservation);
            } else if (equipmentData['selector'] == 'BREWSET') {
              brewsetReservations.add(reservation);
            }
          });
        }
      } catch (e) {
        print('Error fetching equipment details for ID ${reservation['equipment']}: $e');
      }
    }
  }

  Widget buildEquipmentReservationSection(
      String title, List<Map<String, dynamic>> reservations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...reservations.map((reservation) => Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sprzęt: ${reservation['equipment_name']} (Pojemność: ${reservation['equipment_capacity']})',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Visibility(
                      visible: widget.elementData?['equipment_reservations'] != null,
                      child: Expanded(
                        child: EnumField(
                          label: 'Typ',
                          jsonFieldName: 'selector',
                          options: widget.enumOptions?['selector'] ?? [],
                          selectedValue: reservation['selector'] ?? '',
                          editable: false,
                          onChanged: (newValue) {
                            setState(() {
                              reservation['selector'] = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DatePickerField(
                        label: 'Początek',
                        jsonFieldName: 'start_date',
                        initialValue: reservation['start_date'] ?? '',
                        editable: false,
                        onSaved: (newValue) {
                          reservation['start_date'] = newValue;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DatePickerField(
                        label: 'Koniec',
                        jsonFieldName: 'end_date',
                        initialValue: reservation['end_date'] ?? '',
                        editable: false,
                        onSaved: (newValue) {
                          reservation['end_date'] = newValue;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget buildWorkersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Authorized Workers',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          itemCount: authorizedWorkers.length,
          itemBuilder: (context, index) {
            final worker = authorizedWorkers[index];
            return Card(
              child: ListTile(
                title: Text('${worker['first_name']} ${worker['last_name']}'),
                subtitle: Text('ID: ${worker['identificator']}'),
              ),
            );
          },
        ),
      ],
    );
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

    return Scaffold(
      appBar: MyAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(50),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(widget.title,
                      style: Theme.of(context).textTheme.titleSmall),
                  const Spacer(),
                  ...?widget.buttons,
                  Row(children: widget.options ?? []),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildEquipmentReservationSection('Kadź', vatReservations),
                        const SizedBox(height: 24),
                        buildEquipmentReservationSection('Zestaw do warzenia', brewsetReservations),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildWorkersList(),
                        const SizedBox(height: 24),
                        ...generateFieldsWidgets(fieldValues),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
