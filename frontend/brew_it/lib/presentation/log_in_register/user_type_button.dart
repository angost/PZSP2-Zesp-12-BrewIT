import 'package:brew_it/core/theme/colors.dart';
import 'package:brew_it/presentation/log_in_register/register_page.dart';
import 'package:flutter/material.dart';

class UserTypeButton extends StatefulWidget {
  UserTypeButton(this.userType, {super.key});

  final String userType;
  final Map typeToName = {
    "commercial": "Browar komercyjny",
    "contract": "Browar kontraktowy"
  };
  final Map typeToDescription = {
    "commercial": "Oferujesz wypożyczenie swoich urządzeń za opłatą.",
    "contract":
        "Masz swoje receptury i pracowników, ale potrzebujesz wypożyczyć czyjś sprzęt."
  };

  @override
  State<UserTypeButton> createState() => _UserTypeButtonState();
}

class _UserTypeButtonState extends State<UserTypeButton> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onHover: (val) {
          setState(() {
            isHover = val;
          });
        },
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RegisterPage(widget.userType)));
        },
        child: SizedBox(
          width: 250,
          height: 300,
          child: Container(
            decoration: BoxDecoration(
              color: isHover ? secondaryTransparentColor : Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.typeToName[widget.userType],
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: secondaryColor, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Center(
                      child: Text(
                    widget.typeToDescription[widget.userType],
                    textAlign: TextAlign.center,
                  )),
                )
              ],
            ),
          ),
        ));
    ;
  }
}
