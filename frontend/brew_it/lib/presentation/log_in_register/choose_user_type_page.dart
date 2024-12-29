import 'package:brew_it/presentation/_common/widgets/my_app_bar.dart';
import 'package:brew_it/presentation/log_in_register/register_page.dart';
import 'package:flutter/material.dart';

class ChooseUserTypePage extends StatelessWidget {
  const ChooseUserTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(context, hasHomeButtom: false),
        body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(
            "Jakie konto chcesz założyć?",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  color: Colors.grey.shade600,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 120),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RegisterPage("commercial")));
                      },
                      child: const Text(
                        "Browar komercyjny",
                      ),
                    ),
                  )),
              Container(
                  color: Colors.grey.shade600,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 120),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RegisterPage("contract")));
                      },
                      child: const Text(
                        "Browar kontraktowy",
                      ),
                    ),
                  )),
            ],
          ),
        ]));
  }
}
