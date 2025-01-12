import 'package:brew_it/core/helper/field_names.dart';
import 'package:brew_it/presentation/_common/templates/details_add_edit_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/contract/commercial_offers/commercial_offers_page.dart';
import 'package:flutter/material.dart';

class CommercialOffersFilterPage extends StatelessWidget {
  final Map elementData;

  CommercialOffersFilterPage(this.elementData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use DetailsAddEditPageTemplate to organize your data or fetch configuration
    final template = DetailsAddEditPageTemplate(
      title: "Filtruj oferty komercyjne:",
      buttons: [
        MainButton("Aplikuj filtry",
            type: "primary_small",
            apiCall: "/offers/filtered/",
            apiCallType: "post_use_response_data",
            formKey: GlobalKey<FormState>(),
            navigateToPage: (Map elementData, List filteredElements) {
              return CommercialOffersPage(elementData, filteredElements);
            },
            dataForPage: elementData),
        MainButton(
          "Anuluj",
          type: "secondary_small",
          pop: true,
        ),
      ],
      fieldNames: CommercialOffersFiltersFieldNames().fieldNames,
      jsonFieldNames: CommercialOffersFiltersFieldNames().jsonFieldNames,
      fieldEditable: List.filled(
          CommercialOffersFiltersFieldNames().fieldNames.length, true),
      elementData: elementData,
    );

    // Use the template's data to build your UI
    return Scaffold(
      appBar: AppBar(title: Text(template.title)),
      body: Form(
        child: ListView(
          children: [
            // Tank filters
            const Text(
              "Filtry Zbiornika",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8), // Add space below the heading
            DatePickerField(
              label: "Zbiornik - data początkowa",
              jsonFieldName: "vat_start_date",
            ),
            const SizedBox(height: 16), // Space between fields
            DatePickerField(
              label: "Zbiornik - data końcowa",
              jsonFieldName: "vat_end_date",
            ),
            const SizedBox(height: 16),
            NumericField(
              label: "Zbiornik - pojemność",
              jsonFieldName: "vat_capacity",
            ),
            const SizedBox(height: 16),
            NumericField(
              label: "Zbiornik - temperatura minimalna",
              jsonFieldName: "vat_min_temperature",
            ),
            const SizedBox(height: 16),
            NumericField(
              label: "Zbiornik - temperatura maksymalna",
              jsonFieldName: "vat_max_temperature",
            ),
            const SizedBox(height: 16),
            EnumField(
              label: "Zbiornik - typ pakowania",
              jsonFieldName: "vat_package_type",
              options: ["Butelka", "Puszka", "Beczka"],
            ),
            const Divider(height: 32, thickness: 2), // Add a divider between sections

            // Brewset Filters Group
            const Text(
              "Filtry Zestawu do Warzenia",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DatePickerField(
              label: "Zestaw do warzenia - data początkowa",
              jsonFieldName: "brewset_start_date",
            ),
            const SizedBox(height: 16),
            DatePickerField(
              label: "Zestaw do warzenia - data końcowa",
              jsonFieldName: "brewset_end_date",
            ),
            const SizedBox(height: 16),
            NumericField(
              label: "Zestaw do warzenia - pojemność",
              jsonFieldName: "brewset_capacity",
            ),
            const Divider(height: 32, thickness: 2),

            // Other Filters Group
            const Text(
              "Inne Filtry",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            BooleanField(
              label: "Zezwala na bakterie",
              jsonFieldName: "uses_bacteria",
            ),
            const SizedBox(height: 16),
            BooleanField(
              label: "Zezwala na dzielenie sektorów",
              jsonFieldName: "allows_sector_share",
            ),
            const SizedBox(height: 16),
            NumericField(
              label: "Ph wody minimalne",
              jsonFieldName: "water_ph_min",
            ),
            const SizedBox(height: 16),
            NumericField(
              label: "Ph wody maksymalne",
              jsonFieldName: "water_ph_max",
            ),
          ],
        ),
      ),
    );
  }
}

// Additional Widgets
class DatePickerField extends StatelessWidget {
  final String label;
  final String jsonFieldName;

  const DatePickerField({
    required this.label,
    required this.jsonFieldName,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        // Handle date selection
      },
    );
  }
}

class BooleanField extends StatelessWidget {
  final String label;
  final String jsonFieldName;

  const BooleanField({
    required this.label,
    required this.jsonFieldName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Switch(
          value: false, // Bind this value to your state
          onChanged: (bool value) {
            // Handle toggle change
          },
        ),
      ],
    );
  }
}

class NumericField extends StatelessWidget {
  final String label;
  final String jsonFieldName;

  const NumericField({
    required this.label,
    required this.jsonFieldName,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }
}

class EnumField extends StatelessWidget {
  final String label;
  final String jsonFieldName;
  final List<String> options;

  const EnumField({
    required this.label,
    required this.jsonFieldName,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      items: options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: (String? value) {
        // Handle dropdown change
      },
    );
  }
}
