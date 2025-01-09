import 'package:brew_it/presentation/admin/home_page_admin.dart';
import 'package:brew_it/presentation/commercial/home_page_commercial.dart';
import 'package:brew_it/presentation/contract/home_page_contract.dart';
import 'package:flutter/material.dart';
import 'package:brew_it/core/helper/user_data.dart' as user_data;

class MyAppBar extends AppBar {
  MyAppBar(BuildContext context, {bool hasHomeButtom = true, super.key})
      : super(
            leading: hasHomeButtom
                ? IconButton(
                    onPressed: () {
                      if (user_data.userRole != "") {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          if (user_data.userRole == "PROD") {
                            return HomePageCommercial();
                          } else if (user_data.userRole == "CONTR") {
                            return HomePageContract();
                          } else {
                            return HomePageAdmin();
                          }
                        }));
                      }
                    },
                    icon: const Icon(Icons.home))
                : Container(),
            automaticallyImplyLeading: false);
}
