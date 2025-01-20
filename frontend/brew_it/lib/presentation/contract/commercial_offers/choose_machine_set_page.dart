import 'package:brew_it/core/theme/colors.dart';
import 'package:brew_it/injection_container.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_app_bar.dart';
import 'package:brew_it/presentation/contract/commercial_offers/reservation_request_add_page.dart';
import 'package:brew_it/presentation/contract/commercial_offers/details_page.dart';
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

  @override
  void initState() {
    super.initState();
    fetchData();

    if (widget.filtersData != null) {
      vatDays = calculateDays(widget.filtersData!["vat_start_date"],
          widget.filtersData!["vat_end_date"]);
      brewsetDays = calculateDays(widget.filtersData!["brewset_start_date"],
          widget.filtersData!["brewset_end_date"]);
    }
  }

  int calculateDays(String startDate, String endDate) {
    final start = DateTime.parse(startDate);
    final end = DateTime.parse(endDate);
    return end.difference(start).inDays + 1;
  }

  Future<void> fetchData() async {
    try {
      if (widget.filtersData == null) {
        throw DioException(requestOptions: RequestOptions());
      }

      final Map vatData = {
        "selector": "VAT",
        "production_brewery": widget.commercialId,
        "start_date": widget.filtersData!["vat_start_date"],
        "end_date": widget.filtersData!["vat_end_date"],
        "capacity": widget.filtersData!["vat_capacity"],
        "min_temperature": widget.filtersData!["vat_min_temperature"],
        "max_temperature": widget.filtersData!["vat_max_temperature"],
        "package_type": widget.filtersData!["vat_package_type"],
        "uses_bacteria": widget.filtersData!["uses_bacteria"],
        "allows_sector_share": widget.filtersData!["allows_sector_share"],
      };

      final Map brewsetData = {
        "selector": "BREWSET",
        "production_brewery": widget.commercialId,
        "start_date": widget.filtersData!["brewset_start_date"],
        "end_date": widget.filtersData!["brewset_end_date"],
        "capacity": widget.filtersData!["brewset_capacity"],
        "package_type": widget.filtersData!["vat_package_type"],
        "uses_bacteria": widget.filtersData!["uses_bacteria"],
        "allows_sector_share": widget.filtersData!["allows_sector_share"],
      };

      final responseVat =
      await getIt<Dio>().post("/equipment/filtered/", data: vatData);
      if (responseVat.statusCode == 200) {
        setState(() {
          vatElements = responseVat.data;
        });
      } else {
        print("An error occurred");
      }

      final responseBrewset =
      await getIt<Dio>().post("/equipment/filtered/", data: brewsetData);
      if (responseBrewset.statusCode == 200) {
        setState(() {
          brewsetElements = responseBrewset.data;
        });
      } else {
        print("An error occurred");
      }
    } on DioException catch (e) {
      print("An error occurred: $e");
    }
  }

  void showMachineDetails(Map machineData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(elementData: machineData),
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
                        "price": (chosenBrewsetPrice * brewsetDays) + (chosenVatPrice * vatDays),
                        "equipment_reservation_requests": [
                          {
                            "start_date": widget.filtersData!["vat_start_date"],
                            "end_date": widget.filtersData!["vat_end_date"],
                            "equipment": chosenVatId
                          },
                          {
                            "start_date":
                            widget.filtersData!["brewset_start_date"],
                            "end_date": widget.filtersData!["brewset_end_date"],
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
                        "Wybierz kocioł:",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        "Wybierz zestaw do warzenia",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
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
                            final vatPrice = double.tryParse(vat["daily_price"]) ?? 0.0;
                            final vatId = vat["equipment_id"];
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () => showMachineDetails(vat),
                                  child: Text(vat["name"]),
                                ),
                                Text(" - ${vatPrice.toStringAsFixed(2)} PLN/dzień"),
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
                                GestureDetector(
                                  onTap: () => showMachineDetails(brewset),
                                  child: Text(brewset["name"]),
                                ),
                                Text(" - ${brewsetPrice.toStringAsFixed(2)} PLN/dzień"),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      chosenBrewsetId = brewsetId;
                                      chosenBrewsetPrice = brewsetPrice;
                                    });
                                  },
                                  icon: const Icon(Icons.check),
                                  color: chosenBrewsetId ==
                                      brewsetId
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
                  const SizedBox(height: 20),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
