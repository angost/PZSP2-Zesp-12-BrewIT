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
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
