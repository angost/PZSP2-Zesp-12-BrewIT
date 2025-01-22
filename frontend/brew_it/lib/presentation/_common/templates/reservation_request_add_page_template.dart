import 'package:flutter/material.dart';

class WorkerMultiSelectField extends StatefulWidget {
  final String label;
  final List<Worker> selectedWorkers;
  final Function(List<Worker>) onChanged;
  final bool editable;

  const WorkerMultiSelectField({
    required this.label,
    required this.selectedWorkers,
    required this.onChanged,
    this.editable = true,
    Key? key,
  }) : super(key: key);

  @override
  State<WorkerMultiSelectField> createState() => _WorkerMultiSelectFieldState();
}

class _WorkerMultiSelectFieldState extends State<WorkerMultiSelectField> {
  List<Worker> workers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWorkers();
  }

  Future<void> fetchWorkers() async {
    try {
      final response = await getIt<Dio>().get('/workers/');
      if (response.statusCode == 200) {
        final List<Worker> fetchedWorkers = (response.data as List)
            .map((worker) => Worker.fromJson(worker))
            .toList();
        setState(() {
          workers = fetchedWorkers;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching workers: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: baseTextTheme.bodyLarge),
        const SizedBox(height: 8),
        if (isLoading)
          const CircularProgressIndicator()
        else
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: workers.length,
              itemBuilder: (context, index) {
                final worker = workers[index];
                final isSelected = widget.selectedWorkers
                    .any((selected) => selected.id == worker.id);

                return CheckboxListTile(
                  title: Text('${worker.firstName} ${worker.lastName} (${worker.identificator})'),
                  value: isSelected,
                  enabled: widget.editable,
                  onChanged: widget.editable
                      ? (bool? value) {
                    List<Worker> newSelection = List.from(widget.selectedWorkers);
                    if (value ?? false) {
                      if (!isSelected) {
                        newSelection.add(worker);
                      }
                    } else {
                      newSelection.removeWhere((selected) => selected.id == worker.id);
                    }
                    widget.onChanged(newSelection);
                  }
                      : null,
                );
              },
            ),
          ),
      ],
    );
  }
}

class Worker {
  final int id;
  final String firstName;
  final String lastName;
  final String identificator;
  final int brewery;

  Worker({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.identificator,
    required this.brewery,
  });

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      identificator: json['identificator'] as String,
      brewery: json['brewery'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'identificator': identificator,
      'brewery': brewery,
    };
  }
}

class ReservationRequestAddEditTemplate extends DetailsAddEditPageTemplate {
  ReservationRequestAddEditTemplate({
    required String title,
    required List<String> fieldNames,
    required List<String> jsonFieldNames,
    List<String>? fieldTypes,
    List<bool>? fieldEditable,
    Map<String, dynamic>? elementData,
    List<MainButton>? buttons,
    List<MyIconButton>? options,
    Key? key,
  }) : super(
    title: title,
    fieldNames: fieldNames,
    jsonFieldNames: jsonFieldNames,
    fieldTypes: fieldTypes,
    fieldEditable: fieldEditable,
    elementData: elementData,
    buttons: buttons,
    options: options,
    key: key,
  );

  @override
  State<ReservationRequestAddEditTemplate> createState() =>
      _ReservationRequestAddEditTemplateState();
}

class _ReservationRequestAddEditTemplateState
    extends State<ReservationRequestAddEditTemplate> {
  List<Worker> selectedWorkers = [];

  @override
  void initState() {
    super.initState();
    if (widget.elementData != null && widget.elementData!['workers'] != null) {
      selectedWorkers = (widget.elementData!['workers'] as List)
          .map((worker) => Worker.fromJson(worker))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseWidget = super.build(context) as Scaffold;
    final body = baseWidget.body as Padding;
    final stack = body.child as Stack;

    // Add the worker selection field to the form
    final column = stack.children[1] as Column;
    final form = column.children[1] as Expanded;
    final row = form.child as Form;

    return Scaffold(
      appBar: baseWidget.appBar,
      body: Padding(
        padding: body.padding,
        child: Stack(
          children: [
            stack.children[0],
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                column.children[0],
                Expanded(
                  flex: 8,
                  child: Form(
                    key: (row as Row).key,
                    child: Column(
                      children: [
                        Expanded(
                          child: row,
                        ),
                        const SizedBox(height: 20),
                        WorkerMultiSelectField(
                          label: 'Assigned Workers',
                          selectedWorkers: selectedWorkers,
                          onChanged: (workers) {
                            setState(() {
                              selectedWorkers = workers;
                              widget.elementData ??= {};
                              widget.elementData!['workers'] =
                                  workers.map((w) => w.toJson()).toList();
                            });
                          },
                          editable: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}