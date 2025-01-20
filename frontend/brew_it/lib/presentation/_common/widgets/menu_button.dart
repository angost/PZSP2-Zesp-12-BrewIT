import 'package:brew_it/core/theme/colors.dart';
import 'package:brew_it/injection_container.dart';
import 'package:brew_it/presentation/log_in_register/log_in_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:brew_it/core/helper/user_data.dart' as user_data;

class MenuButton extends StatefulWidget {
  MenuButton({required this.type, this.navigateToPage, super.key});

  final String type;
  final Widget? navigateToPage;

  final typeToIcon = {
    "machines": const Icon(Icons.precision_manufacturing_outlined),
    "sectors": const Icon(Icons.pie_chart_outline_sharp),
    "reservations": const Icon(Icons.calendar_today),
    "reservation_requests": const Icon(Icons.edit_calendar),
    "commercial_offers": const Icon(Icons.shopping_bag_sharp),
    "production_processes": const Icon(Icons.timeline),
    "recipes": const Icon(Icons.receipt_long),
    "registration_requests": const Icon(Icons.person_add_alt),
    "stats": const Icon(Icons.bar_chart_outlined),
    "logout": const Icon(Icons.logout_rounded),
  };

  final typeToContent = {
    "machines": "Zarządzanie urządzeniami",
    "sectors": "Twoje sektory",
    "reservations": "Twoje rezerwacje",
    "reservation_requests": "Prośby o rezerwację",
    "commercial_offers": "Oferta browarów komercyjnych",
    "production_processes": "Procesy wykonania piwa",
    "recipes": "Twoje receptury",
    "registration_requests": "Prośby o rejestrację",
    "stats": "Statystyki",
    "logout": "Wyloguj się",
  };

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    Color hoverColor = widget.type == "logout"
        ? errorTransparentColor
        : secondaryTransparentColor;

    return InkWell(
        onHover: (val) {
          setState(() {
            isHover = val;
          });
        },
        onTap: () async {
          if (widget.type == "logout") {
            try {
              final response = await getIt<Dio>().post(
                "/logout/",
              );

              if (response.statusCode == 200) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const LogInPage();
                }));
                user_data.userRole = "";
              } else {
                print("An error occured");
              }
            } on DioException catch (e) {
              print("An error occured");
            }
          } else if (widget.navigateToPage != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => widget.navigateToPage!));
          }
        },
        child: SizedBox(
          width: 150,
          height: 150,
          child: Container(
            decoration: BoxDecoration(
              color: isHover ? hoverColor : Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.typeToIcon[widget.type]!,
                Center(
                    child: Text(
                  widget.typeToContent[widget.type]!,
                  textAlign: TextAlign.center,
                ))
              ],
            ),
          ),
        ));
  }
}
