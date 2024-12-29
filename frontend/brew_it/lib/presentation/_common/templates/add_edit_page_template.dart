import 'package:brew_it/presentation/_common/templates/details_add_edit_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:flutter/material.dart';

class AddEditPageTemplate extends DetailsAddEditPageTemplate {
  AddEditPageTemplate(
      {required String title,
      required String apiCall,
      required String apiCallType,
      required Function navigateToPageSave,
      required Function navigateToPageCancel,
      required List<String> fieldNames,
      required List<String> jsonFieldNames,
      required List<bool> fieldEditable,
      required Map elementData,
      super.key})
      : super(
            title: title,
            buttons: [
              MainButton(
                "Zapisz",
                type: "primary_small",
                formKey: GlobalKey<FormState>(),
                apiCall: apiCall,
                apiCallType: apiCallType,
                navigateToPage: navigateToPageSave,
                dataForPage: elementData,
              ),
              MainButton(
                "Anuluj",
                type: "secondary_small",
                navigateToPage: navigateToPageCancel,
                dataForPage: elementData,
              )
            ],
            fieldNames: fieldNames,
            jsonFieldNames: jsonFieldNames,
            fieldEditable: fieldEditable,
            elementData: elementData);
}
