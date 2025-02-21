import 'package:brew_it/presentation/_common/templates/details_add_edit_page_template.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/errors/error_handlers.dart';
import 'package:flutter/material.dart';

class AddEditPageTemplate extends DetailsAddEditPageTemplate {
  AddEditPageTemplate(
      {required String title,
      required String apiCall,
      required String apiCallType,
      required Function navigateToPageSave,
      bool navigateToSaveIsTablePage = false,
      bool navigateToCancelIsTablePage = false,
      required Function navigateToPageCancel,
      required List<String> fieldNames,
      required List<String> jsonFieldNames,
      required List<bool> fieldEditable,
      required Map elementData,
        Map<String, dynamic>? errorMessages,
        List<String>? fieldTypes,
        Map<String, List<Map<String, String>>>? enumOptions,
        List<Map<String, String>>? fetchOptions,
        List<Map<String, String>>? fetchDisplay,
        bool hideFirstField = false,
      super.key})
      : super(
            title: title,
            buttons: [
              MainButton("Zapisz",
                  type: "primary_small",
                  formKey: GlobalKey<FormState>(),
                  apiCall: apiCall,
                  apiCallType: apiCallType,
                  navigateToPage: navigateToPageSave,
                  dataForPage: elementData,
                  navigateIsTablePage: navigateToSaveIsTablePage,
                  errorMessages: errorMessages,
                  customErrorHandler: handleMultipleErrors
              ),
              MainButton("Anuluj",
                  type: "secondary_small",
                  // navigateToPage: navigateToPageCancel,
                  // dataForPage: elementData,
                  // navigateIsTablePage: navigateToCancelIsTablePage
                  pop: true)
            ],
            fieldNames: fieldNames,
            jsonFieldNames: jsonFieldNames,
            fieldEditable: fieldEditable,
            fieldTypes: fieldTypes,
            enumOptions: enumOptions,
            fetchOptions: fetchOptions,
            fetchDisplay: fetchDisplay,
            hideFirstField: hideFirstField,
            elementData: elementData);
}
