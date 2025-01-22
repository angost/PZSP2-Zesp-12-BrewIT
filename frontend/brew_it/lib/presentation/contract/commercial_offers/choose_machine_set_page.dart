import 'package:brew_it/core/theme/colors.dart';
import 'package:brew_it/injection_container.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_app_bar.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:brew_it/presentation/contract/commercial_offers/reservation_request_add_page.dart';
import 'package:brew_it/presentation/contract/commercial_offers/machine_details_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ChooseMachineSetPage extends StatefulWidget {
  ChooseMachineSetPage(Map commercialBreweryData, [this.filtersData]) {
    commercialId = commercialBreweryData["brewery_id"];
  }

  late int commercialId;
  final Map? filtersData;

  @override
  State<ChooseMachineSetPage> createState() => _ChooseMachineSetPageState();
}

class _ChooseMachineSetPageState extends State<ChooseMachineSetPage> {
  List vatElements = [];
  List brewsetElements = [];
  int chosenVatId = -1;
  int chosenBrewsetId = -1;
  double chosenVatPrice = 0.0;
  double chosenBrewsetPrice = 0.0;
  int vatDays = 0;
  int brewsetDays = 0;
  DateTime? vatStartDate;
  DateTime? vatEndDate;
  DateTime? brewsetStartDate;
  DateTime? brewsetEndDate;
  int? brewSize;

  @override
  void initState() {
    super.initState();

    // Initialize dates from filtersData or set to null
    vatStartDate = widget.filtersData?["vat_start_date"] != null
        ? parseDateTime(widget.filtersData!["vat_start_date"])
        : null;
    vatEndDate = widget.filtersData?["vat_end_date"] != null
        ? parseDateTime(widget.filtersData!["vat_end_date"])
        : null;
    brewsetStartDate = widget.filtersData?["brewset_start_date"] != null
        ? parseDateTime(widget.filtersData!["brewset_start_date"])
        : null;
    brewsetEndDate = widget.filtersData?["brewset_end_date"] != null
        ? parseDateTime(widget.filtersData!["brewset_end_date"])
        : null;

    brewSize = (widget.filtersData?["vat_capacity"] ?? 0) > (widget.filtersData?["brewset_capacity"] ?? 0)
        ? (widget.filtersData?["vat_capacity"] as int? ?? 0)
        : (widget.filtersData?["brewset_capacity"] as int? ?? 0);

    vatDays = calculateDays(vatStartDate, vatEndDate);
    brewsetDays = calculateDays(brewsetStartDate, brewsetEndDate);

    fetchData();

  }

  int calculateDays(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      return 0;
    }
    return endDate.difference(startDate).inDays + 1;
  }

  Future<void> fetchData() async {
    try {
      final vatData = {
        "selector": "VAT",
        "production_brewery": widget.commercialId,
        "start_date": parseDate(vatStartDate),
        "end_date": parseDate(vatEndDate),
        "capacity": widget.filtersData?["vat_capacity"] ?? 0,
        "min_temperature": widget.filtersData?["vat_min_temperature"] ?? 0,
        "max_temperature": widget.filtersData?["vat_max_temperature"] ?? 0,
        "package_type": widget.filtersData?["vat_package_type"] ?? null,
        "uses_bacteria": widget.filtersData?["uses_bacteria"] ?? false,
        "allows_sector_share": widget.filtersData?["allows_sector_share"] ?? false,
      };

      final brewsetData = {
        "selector": "BREWSET",
        "production_brewery": widget.commercialId,
        "start_date": parseDate(brewsetStartDate),
        "end_date": parseDate(brewsetEndDate),
        "capacity": widget.filtersData?["brewset_capacity"] ?? 0,
        "uses_bacteria": widget.filtersData?["uses_bacteria"] ?? false,
        "allows_sector_share": widget.filtersData?["allows_sector_share"] ?? false,
      };

      final responseVat =
          await getIt<Dio>().post("/equipment/filtered/", data: vatData);
      if (responseVat.statusCode == 200) {
        setState(() {
          vatElements = responseVat.data;
        });
      } else {
        print("Error fetching VAT data.");
      }

      final responseBrewset =
          await getIt<Dio>().post("/equipment/filtered/", data: brewsetData);
      if (responseBrewset.statusCode == 200) {
        setState(() {
          brewsetElements = responseBrewset.data;
        });
      } else {
        print("Error fetching Brewset data.");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> _selectDateRange(BuildContext context, bool isVat) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      initialDateRange: isVat
          ? DateTimeRange(start: vatStartDate ?? DateTime.now(), end: vatEndDate ?? DateTime.now())
          : DateTimeRange(
              start: brewsetStartDate ?? DateTime.now(),
              end: brewsetEndDate ?? DateTime.now(),
            ),
    );

    if (picked != null) {
      setState(() {
        if (isVat) {
          vatStartDate = picked.start;
          vatEndDate = picked.end;
          vatDays = calculateDays(vatStartDate, vatEndDate);
        } else {
          brewsetStartDate = picked.start;
          brewsetEndDate = picked.end;
          brewsetDays = calculateDays(brewsetStartDate, brewsetEndDate);
        }
      });
    }
  }

  void _applyFilters() {
      final updatedFilters = {
        "vat_start_date": vatStartDate?.toIso8601String().substring(0, 10),
        "vat_end_date": vatEndDate?.toIso8601String().substring(0, 10),
        "brewset_start_date": brewsetStartDate?.toIso8601String().substring(0, 10),
        "brewset_end_date": brewsetEndDate?.toIso8601String().substring(0, 10),
        "vat_capacity": brewSize,
        "brewset_capacity": brewSize
      };

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ChooseMachineSetPage(
            {"brewery_id": widget.commercialId},
            updatedFilters,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () => _selectDateRange(context, true),
                  child: Text(
                      "Set VAT Dates: ${vatStartDate?.toLocal().toShortString() ?? 'Start'} - ${vatEndDate?.toLocal().toShortString() ?? 'End'}"),
                ),
                TextButton(
                  onPressed: () => _selectDateRange(context, false),
                  child: Text(
                      "Set Brewset Dates: ${brewsetStartDate?.toLocal().toShortString() ?? 'Start'} - ${brewsetEndDate?.toLocal().toShortString() ?? 'End'}"),
                ),
              ],
            ),
            TextFormField(
              initialValue: brewSize?.toString(), // Display initial value if brewSize is set
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Wielkość warki",
              ),
              onChanged: (value) {
                setState(() {
                  brewSize = int.tryParse(value);
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Wprowadź wielkość warki"; //
                }
                if (int.tryParse(value) == null) {
                  return "Wprowadź prawidłową liczbę";
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: _applyFilters,
              child: Text("Aplikuj Filtry"),
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Wybierz zestaw urządzeń:",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const Spacer(),
                  MainButton(
                    "Wybierz",
                    type: "primary_small",
                    navigateToPage: () {
                      return ReservationRequestAddPage({
                        "production_brewery": widget.commercialId,
                        "allows_sector_share":
                            widget.filtersData!["allows_sector_share"],
                        "price": (chosenBrewsetPrice * brewsetDays) +
                            (chosenVatPrice * vatDays),
                        "brew_size": brewSize,
                        "equipment_reservation_requests": [
                          {
                            "start_date": parseDate(vatStartDate),
                            "end_date": parseDate(vatEndDate),
                            "equipment": chosenVatId
                          },
                          {
                            "start_date": parseDate(brewsetStartDate),
                            "end_date": parseDate(brewsetEndDate),
                            "equipment": chosenBrewsetId
                          }
                        ],
                      });
                    },
                  ),
                  MainButton(
                    "Anuluj",
                    type: "secondary_small",
                    pop: true,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 8,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Wybierz kocioł",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        "Wybierz zestaw do warzenia",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: vatElements.length,
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                          itemBuilder: (context, index) {
                            final vat = vatElements[index];
                            final vatPrice =
                                double.tryParse(vat["daily_price"]) ?? 0.0;
                            final vatId = vat["equipment_id"];
                            return Row(
                              children: [
                                Text(vat["name"]),
                                Text(
                                    " - ${vatPrice.toStringAsFixed(2)} PLN/dzień"),
                                const SizedBox(
                                  width: 40,
                                ),
                                MyIconButton(
                                  type: "info",
                                  navigateToPage: () {
                                    return MachineDetailsPage(elementData: vat);
                                  },
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      chosenVatId = vatId;
                                      chosenVatPrice = vatPrice;
                                    });
                                  },
                                  icon: const Icon(Icons.check),
                                  color: chosenVatId == vatId
                                      ? Colors.green
                                      : primaryTransparentColor,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: brewsetElements.length,
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                          itemBuilder: (context, index) {
                            final brewset = brewsetElements[index];
                            final brewsetPrice =
                                double.tryParse(brewset["daily_price"]) ?? 0.0;
                            final brewsetId = brewset["equipment_id"];
                            return Row(
                              children: [
                                Text(brewset["name"]),
                                Text(
                                    " - ${brewsetPrice.toStringAsFixed(2)} PLN/dzień"),
                                const SizedBox(
                                  width: 40,
                                ),
                                MyIconButton(
                                  type: "info",
                                  navigateToPage: () {
                                    return MachineDetailsPage(
                                        elementData: brewset);
                                  },
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      chosenBrewsetId = brewsetId;
                                      chosenBrewsetPrice = brewsetPrice;
                                    });
                                  },
                                  icon: const Icon(Icons.check),
                                  color: chosenBrewsetId == brewsetId
                                      ? Colors.green
                                      : primaryTransparentColor,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    "Dzienna cena wypożyczenia kadzi: ${chosenVatPrice.toStringAsFixed(2)} PLN",
                  ),
                  Text(
                    "Cena wypożyczenia kadzi (${chosenVatPrice.toStringAsFixed(2)} x $vatDays dni): ${(chosenVatPrice) * vatDays} PLN",
                  ),
                  Text(
                    "Dzienna cena wypożyczenia zestawu do warzenia: ${chosenBrewsetPrice.toStringAsFixed(2)} PLN",
                  ),
                  Text(
                    "Cena wypożyczenia zestawu do warzenia (${chosenBrewsetPrice.toStringAsFixed(2)} PLN x $brewsetDays dni): ${(chosenBrewsetPrice) * brewsetDays} PLN",
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


extension DateShortString on DateTime {
  String toShortString() {
    return "${this.day}/${this.month}/${this.year}";
  }
}

String? parseDate(DateTime? pickedDate) {
  if (pickedDate == null) {
    return null;
  }
  // Ensure only the date is used, ignoring the time component
  return "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
}

DateTime? parseDateTime(String? date) {
  if (date == null || date.isEmpty) return null;

  try {
    final parts = date.split("-");
    if (parts.length == 3) {
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);
      return DateTime(year, month, day);
    }
  } catch (e) {
    print("Error parsing date: $e");
  }

  return null; // Return null if parsing fails
}
