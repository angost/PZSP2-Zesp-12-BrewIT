import 'package:brew_it/presentation/_common/widgets/my_app_bar.dart';
import 'package:brew_it/presentation/log_in_register/user_type_button.dart';
import 'package:flutter/material.dart';

class ChooseUserTypePage extends StatelessWidget {
  const ChooseUserTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(context),
        body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(
            "Jakie konto chcesz założyć?",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              UserTypeButton("commercial"),
              UserTypeButton("contract"),
            ],
          ),
        ]));
  }
}
