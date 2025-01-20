import 'package:brew_it/injection_container.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_app_bar.dart';
import 'package:brew_it/presentation/admin/home_page_admin.dart';
import 'package:brew_it/presentation/contract/home_page_contract.dart';
import 'package:brew_it/presentation/log_in_register/choose_user_type_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:brew_it/presentation/commercial/home_page_commercial.dart';
import 'package:brew_it/core/helper/user_data.dart' as user_data;
import 'package:brew_it/presentation/_common/errors/error_handlers.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  Map<String, dynamic> errorMessages = {
    "detail": {
      "Email or Password is incorrect.": "Nieprawidłowy email lub hasło."
    }
  };
  Map logInData = {"email": "", "password": ""};
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(context, hasHomeButtom: false),
        body: Padding(
          padding: const EdgeInsets.all(50),
          child: Stack(
            children: [
              Center(
                child: Form(
                    key: formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Zaloguj się",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(
                            width: 400,
                            child: TextFormField(
                              onSaved: (newValue) {
                                logInData["email"] = newValue;
                              },
                              decoration:
                                  const InputDecoration(labelText: "Email"),
                            ),
                          ),
                          SizedBox(
                            width: 400,
                            child: TextFormField(
                              onSaved: (newValue) {
                                logInData["password"] = newValue;
                              },
                              obscureText: true,
                              decoration:
                                  const InputDecoration(labelText: "Hasło"),
                            ),
                          ),
                          MainButton(
                            "Zaloguj",
                            type: "primary_big",
                            customOnPressed: () async {
                              formKey.currentState!.save();
                              try {
                                final response = await getIt<Dio>().post(
                                  '/login/',
                                  data: logInData,
                                );
                                if (response.statusCode == 200) {
                                  user_data.userRole =
                                      response.data["user_role"];
                                  if (response.data["user_role"] == "PROD") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomePageCommercial()));
                                  } else if (response.data["user_role"] ==
                                      "CONTR") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomePageContract()));
                                  } else if (response.data["user_role"] ==
                                      "ADMIN") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomePageAdmin()));
                                  } else {
                                    print("Unknown user role");
                                    user_data.userRole = "";
                                  }
                                } else {
                                  print("Log in failed");
                                }
                              } on DioException catch (e) {
                                print("Log in failed");
                                handleMultipleErrors(context, e, errorMessages);
                              }
                            },
                          )
                        ])),
              ),
              Column(
                children: [
                  const Spacer(),
                  Row(
                    children: [
                      const Spacer(),
                      MainButton(
                        "Nie mam konta",
                        type: "secondary_big",
                        navigateToPage: () {
                          return const ChooseUserTypePage();
                        },
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }
}
