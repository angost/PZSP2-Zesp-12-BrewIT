import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/injection_container.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_app_bar.dart';
import 'package:brew_it/presentation/log_in_register/log_in_page.dart';
import 'package:brew_it/presentation/_common/errors/error_handlers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage(this.userType, {super.key});

  final String userType;
  final Map typeToText = {
    "commercial": "Browar komercyjny",
    "contract": "Browar kontraktowy"
  };

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  late StandardFieldNames registerFieldNames;
  Map registerData = {};

  @override
  void initState() {
    super.initState();
    if (widget.userType == "commercial") {
      registerData["selector"] = "PROD";
      registerFieldNames = RegisterCommercialFieldNames();
    } else {
      registerData["selector"] = "CONTR";
      // registerData["water_ph"] = "0";
      registerFieldNames = RegisterContractFieldNames();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(context),
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
                        children: <Widget>[
                              Text(
                                "Zarejestruj się - ${widget.typeToText[widget.userType]}",
                                style: Theme.of(context).textTheme.titleLarge,
                              )
                            ] +
                            List.generate(
                                registerFieldNames.fieldNames.length,
                                (index) => SizedBox(
                                      width: 400,
                                      child: TextFormField(
                                        onSaved: (newValue) {
                                          registerData[registerFieldNames
                                                  .jsonFieldNames[index]] =
                                              newValue;
                                        },
                                        obscureText: registerFieldNames
                                            .jsonFieldNames[index]
                                            .contains("password"),
                                        decoration: InputDecoration(
                                            labelText: registerFieldNames
                                                .fieldNames[index]),
                                      ),
                                    )) +
                            [
                              MainButton("Wyślij prośbę", type: "primary_big",
                                  customOnPressed: () async {
                                formKey.currentState!.save();
                                try {
                                  final response = await getIt<Dio>().post(
                                    '/registration-requests/',
                                    data: registerData,
                                  );
                                  if (response.statusCode == 201) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LogInPage()));
                                  } else {
                                    print("Register failed");
                                  }
                                } on DioException catch (e) {
                                  print("Register failed");
                                  handleMultipleErrors(context, e,
                                      registerFieldNames.errorMessages);
                                }
                              })
                            ])),
              ),
              Column(
                children: [
                  const Spacer(),
                  Row(
                    children: [
                      const Spacer(),
                      MainButton(
                        "Mam już konto",
                        type: "secondary_big",
                        navigateToPage: () {
                          return const LogInPage();
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
