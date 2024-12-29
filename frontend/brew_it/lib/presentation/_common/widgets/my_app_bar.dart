import 'package:brew_it/presentation/log_in_register/log_in_page.dart';
import 'package:flutter/material.dart';

class MyAppBar extends AppBar {
  MyAppBar(BuildContext context, {bool hasHomeButtom = true, super.key})
      : super(
            leading: hasHomeButtom
                ? IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LogInPage()));
                    },
                    icon: const Icon(Icons.home))
                : Container(),
            automaticallyImplyLeading: false);
}
