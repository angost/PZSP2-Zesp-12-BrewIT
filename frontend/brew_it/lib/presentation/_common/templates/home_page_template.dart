import 'package:brew_it/presentation/_common/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';

class HomePageTemplate extends StatelessWidget {
  const HomePageTemplate(
      {required this.title, required this.buttons, super.key});

  final String title;
  final List<Widget> buttons;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(context),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 2, child: Container()),
          Center(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: buttons,
              )),
          Expanded(flex: 2, child: Container())
        ]));
  }
}
