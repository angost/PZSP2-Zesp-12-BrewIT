import 'package:brew_it/core/theme/button_themes.dart';
import 'package:brew_it/core/theme/colors.dart';
import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
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
    "reservation_requests": "Prośby o rezerwację od browarów kontraktowych",
    "commercial_offers": "Oferta browarów komercyjnych",
    "production_processes": "Procesy wykonania piwa",
    "recipes": "Twoje receptury",
    "registration_requests": "Prośby o rejestrację",
    "stats": "Statystyki",
    "logout": "Wyloguj się",
  };

  @override
  Widget build(BuildContext context) {
    return InkWell(
        hoverColor: Colors.red,
        child: SizedBox(
          width: 300,
          height: 300,
          child: Container(
            color: Colors.white,
            child: Column(
              children: [typeToIcon[type]!, Text(typeToContent[type]!)],
            ),
          ),
        ));

    // ElevatedButton(
    //     onPressed: () {
    //       if (navigateToPage != null) {
    //         Navigator.push(context,
    //             MaterialPageRoute(builder: (context) => navigateToPage!));
    //       }
    //     },
    //     style: tertiaryButtonTheme.style!.copyWith(
    //         backgroundColor: WidgetStateProperty.all(
    //             typeToColor.containsKey(type)
    //                 ? typeToColor[type]
    //                 : typeToColor["default"])),
    //     child: Text(content));
  }
}
