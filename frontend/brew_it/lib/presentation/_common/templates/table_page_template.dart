import 'package:brew_it/injection_container.dart';
import 'package:brew_it/presentation/_common/widgets/main_button.dart';
import 'package:brew_it/presentation/_common/widgets/my_app_bar.dart';
import 'package:brew_it/presentation/_common/widgets/my_icon_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'dart:html' as html;

class TablePageTemplate extends StatefulWidget {
  const TablePageTemplate(
      {required this.title,
      this.button,
      required this.headers,
      this.options,
      this.apiString,
      this.jsonFields,
      super.key});

  final String title;
  final MainButton? button;
  final List<String> headers;
  final List<MyIconButton>? options;
  final String? apiString;
  final List<String>? jsonFields;

  @override
  State<TablePageTemplate> createState() => _TablePageTemplateState();
}

class _TablePageTemplateState extends State<TablePageTemplate> {
  List elements = [];

  @override
  void initState() {
    super.initState();
    if (widget.apiString != null && widget.apiString != "") {
      fetchData();
    }
  }

  Future<void> fetchData() async {
    try {
      final response = await getIt<Dio>().get(widget.apiString!);

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          elements = data;
        });
      } else {
        print("An error occured");
      }
    } on DioException catch (e) {
      print("An error occured");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(context),
        body: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.title,
                        style: Theme.of(context).textTheme.titleSmall),
                    const Spacer(),
                    widget.button ?? Container()
                  ],
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(widget.headers.length,
                        (index) => Text(widget.headers[index])),
                  )),
              const Divider(),
              Expanded(
                  flex: 8,
                  child: ListView.separated(
                      itemCount: elements.length,
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemBuilder: (context, index) {
                        final element = elements[index];
                        List<Text> fieldValues = [];

                        if (widget.jsonFields != null) {
                          fieldValues = List.generate(
                              widget.jsonFields!.length,
                              (index) => Text(element[widget.jsonFields![index]]
                                  .toString()));
                        }

                        List<MyIconButton>? elementButtons;

                        if (widget.options != null) {
                          elementButtons = [];
                          for (MyIconButton optionButton in widget.options!) {
                            elementButtons.add(MyIconButton(
                              type: optionButton.type,
                              navigateToPage: optionButton.navigateToPage,
                              dataForPage: elements[index],
                              customOnPressed: optionButton.customOnPressed,
                            ));
                          }
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 8,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: fieldValues),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(children: elementButtons ?? []),
                            )
                          ],
                        );
                      }))
            ],
          ),
        ));
  }
}
