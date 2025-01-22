import 'package:flutter/material.dart';
import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/details_add_edit_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';

class MachineDetailsPage extends DetailsAddEditPageTemplate {
  MachineDetailsPage({required Map elementData, Key? key})
      : super(
          key: key,
          title: "Urządzenie - szczegóły:",
          buttons: [
            MainButton(
              "Cofnij",
              type: "secondary_small",
              pop: true,
            )
          ],
          fieldNames: MachinesFieldNames().fieldNames,
          jsonFieldNames: MachinesFieldNames().jsonFieldNames,
          elementData: elementData,
        );
}
