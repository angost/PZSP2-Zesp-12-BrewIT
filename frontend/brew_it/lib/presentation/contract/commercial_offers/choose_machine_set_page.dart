import 'package:brew_it/core/theme/colors.dart';
import 'package:brew_it/injection_container.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_app_bar.dart';
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

  @override
  void initState() {
    super.initState();
    fetchData();
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
        "max_temperature": widget.filtersData!["vat_min_temperature"],
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
        print("An error occured");
      }

      final responseBrewset =
          await getIt<Dio>().post("/equipment/filtered/", data: brewsetData);
      if (responseBrewset.statusCode == 200) {
        setState(() {
          brewsetElements = responseBrewset.data;
        });
      } else {
        print("An error occured");
      }

      print(vatElements);
      print(brewsetElements);
    } on DioException catch (e) {
      print("An error occured");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(context),
        body: Padding(
            padding: const EdgeInsets.all(50),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Expanded(
                flex: 1,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Wybierz zestaw urządzeń:",
                          style: Theme.of(context).textTheme.titleSmall),
                      const Spacer(),
                      MainButton(
                        "Wybierz",
                        type: "primary_small",
                      ),
                      MainButton(
                        "Anuluj",
                        type: "secondary_small",
                      )
                    ]),
              ),
              Expanded(
                  flex: 8,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Wybierz kocioł:",
                              style: Theme.of(context).textTheme.titleSmall),
                          Text("Wybierz zestaw do warzenia",
                              style: Theme.of(context).textTheme.titleSmall)
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
                              return Row(
                                children: [
                                  Text(vatElements[index]["name"]),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        chosenVatId =
                                            vatElements[index]["equipment_id"];
                                      });
                                    },
                                    icon: const Icon(Icons.check),
                                    color: chosenVatId ==
                                            vatElements[index]["equipment_id"]
                                        ? Colors.green
                                        : primaryTransparentColor,
                                  )
                                ],
                              );
                            },
                          )),
                          Flexible(
                              child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: brewsetElements.length,
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Text(brewsetElements[index]["name"]),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        chosenBrewsetId = brewsetElements[index]
                                            ["equipment_id"];
                                      });
                                    },
                                    icon: const Icon(Icons.check),
                                    color: chosenBrewsetId ==
                                            brewsetElements[index]
                                                ["equipment_id"]
                                        ? Colors.green
                                        : primaryTransparentColor,
                                  )
                                ],
                              );
                            },
                          ))
                        ],
                      ),
                    ],
                  ))
            ])));
  }
}
