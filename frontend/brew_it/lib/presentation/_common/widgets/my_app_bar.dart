import 'package:brew_it/presentation/admin/home_page_admin.dart';
import 'package:brew_it/presentation/commercial/home_page_commercial.dart';
import 'package:brew_it/presentation/contract/home_page_contract.dart';
import 'package:brew_it/presentation/log_in_register/log_in_page.dart';
import 'package:flutter/material.dart';
import 'package:brew_it/core/helper/user_data.dart' as user_data;

class MyAppBar extends AppBar {
  MyAppBar(BuildContext context,
      {bool hasHomeButton = true, bool hasBackButton = false, super.key})
      : super(
            leading: hasHomeButton
                ? IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        if (user_data.userRole == "PROD") {
                          return HomePageCommercial();
                        } else if (user_data.userRole == "CONTR") {
                          return HomePageContract();
                        } else if (user_data.userRole == "ADMIN") {
                          return HomePageAdmin();
                        } else {
                          user_data.userRole = "";
                          return const LogInPage();
                        }
                      }));
                    },
                    icon: const Icon(Icons.home))
                : (hasBackButton
                    ? IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.undo))
                    : Container()),
            automaticallyImplyLeading: false);
}
