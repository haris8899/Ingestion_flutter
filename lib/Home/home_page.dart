import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ingestion_app/Controllers/fileUploadController.dart';
import 'package:ingestion_app/Controllers/qdrantController.dart';
import 'package:ingestion_app/Widgets/decorated_text_field.dart';
import 'package:ingestion_app/Widgets/my_button.dart';
import 'package:ingestion_app/Widgets/small_text.dart';
import 'package:ingestion_app/endpoints/qdrant_endpoints.dart';
import 'package:ingestion_app/utils/dimensions.dart';

import '../Widgets/large_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //List<dynamic> _items = [];
  // Future<void> fetchdata() async {
  //   final data = await getSourcesController.getSources();
  //   print(data);
  //   setState(() {
  //     _items = data;
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshList();
    SearchController.addListener(
      () {
        setState(
          () {
            _query = SearchController.text;

            filteredItems = sources
                .where(
                  (item) => item.toLowerCase().contains(
                        _query.toLowerCase(),
                      ),
                )
                .toList();
          },
        );
      },
    );
    //fetchdata();
  }

  void _filterList() {
    String searchText = SearchController.text.toLowerCase();
    setState(() {
      filteredItems = sources
          .where((item) => item.toLowerCase().contains(searchText))
          .toList();
    });
  }

  Future<Map<String, dynamic>> getSources() async {
    Map<String, dynamic> items = await qdrantController.getSources();
    //print(items);
    return items;
  }

  List<dynamic> sources = [];
  Map<String, dynamic> sourcesMap = {};
  List<dynamic> filteredItems = [];
  TextEditingController SearchController = TextEditingController();
  String _query = '';
  void search(String query) {
    setState(
      () {
        _query = query;

        filteredItems = sources
            .where(
              (item) => item.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();
      },
    );
  }

  void refreshList() {
    getSources().then(
      (value) {
        setState(() {
          sourcesMap = value;
          sources = value.keys.toList();
          filteredItems = value.keys.toList();
        });
      },
    );
  }

  void _filterSources(String query) {}

  @override
  Widget build(BuildContext context) {
    print(QdrantEndpoints.getSources());
    //print(_items.length);
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 2, 17, 92),
          title: LargeText(
            text: "AblMuawin Ingestion",
            color: Colors.white,
          ),
          actions: [
            InkWell(
              onTap: () {
                setState(() {
                  sources = [];
                });
                refreshList();
              },
              child: Container(
                  padding: EdgeInsets.all(Dimensions.height10),
                  margin: EdgeInsets.all(Dimensions.height10),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.BorderRadius30),
                      color: Colors.white),
                  child: Icon(Icons.refresh)),
            ),
            Container(
                margin: EdgeInsets.all(Dimensions.height10 / 4),
                child: MyButton(
                  text: "Add Files",
                  color: Colors.white,
                  Textcolor: Colors.black,
                  onTap: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        //dialogContext = context;
                        return AlertDialog(
                          title: LargeText(text: "Adding Files"),
                          contentPadding: EdgeInsets.all(Dimensions.width10),
                          content: CircularProgressIndicator(),
                        );
                      },
                    );
                    FileManager.pickAndUploadFiles().then(
                      (value) {
                        Navigator.of(context).pop();
                        refreshList();
                      },
                    );
                  },
                )),
            Container(
              margin: EdgeInsets.all(Dimensions.height10),
              width: Dimensions.width120,
              child: DecoratedTextField(
                  HintText: "Search", controller: SearchController),
            ),
          ],
        ),
        body: sources.length == 0
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LargeText(text: "Documents"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Number of Documents: " +
                                sources.length.toString()),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap:
                            true, // Let the ListView take only the space it needs
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: Dimensions.screenWidth,
                            margin: EdgeInsets.all(Dimensions.height20),
                            padding: EdgeInsets.all(Dimensions.height10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Colors.grey))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  //width: Dimensions.width120,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.document_scanner),
                                      SizedBox(
                                        width: Dimensions.width10,
                                      ),
                                      Expanded(
                                          //width: Dimensions.width120*3,
                                          flex: 1,
                                          child: LargeText(
                                              text: filteredItems[index])),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      LargeText(
                                              text: sourcesMap[filteredItems[index]].toString()),
                                      SizedBox(width: Dimensions.width15,),
                                      InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    contentPadding: EdgeInsets.all(
                                                        Dimensions.width10),
                                                    content: LargeText(
                                                        text:
                                                            "Are you sure you want to delete the file \n" +
                                                                filteredItems[index] +
                                                                "?"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () async {
                                                            //Navigator.of(context).pop();
                                                            //BuildContext dialogContext;
                                                            showDialog(
                                                              barrierDismissible: false,
                                                              context: context,
                                                              builder: (context) {
                                                                //dialogContext = context;
                                                                return AlertDialog(
                                                                  title: LargeText(
                                                                      text: "Deleting " +
                                                                          filteredItems[
                                                                              index]),
                                                                  contentPadding:
                                                                      EdgeInsets.all(
                                                                          Dimensions
                                                                              .width10),
                                                                  content:
                                                                      CircularProgressIndicator(),
                                                                );
                                                              },
                                                            );
                                                            qdrantController
                                                                .deleteDocument(
                                                                    filteredItems[
                                                                        index])
                                                                .then(
                                                              (value) {
                                                                Navigator.of(context)
                                                                    .pop();
                                        
                                                                Navigator.of(context)
                                                                    .pop();
                                                                setState(() {
                                                                  SearchController
                                                                      .text = "";
                                                                  sources = [];
                                                                  refreshList();
                                                                });
                                                              },
                                                            );
                                                          },
                                                          child: Text("Yes")),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text("Cancel"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Icon(Icons.delete)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Expanded(
                  //   child: ListView.builder(
                  //     shrinkWrap: true, // Let the ListView take only the space it needs
                  //     physics: NeverScrollableScrollPhysics(),
                  //     itemCount: _items.length,
                  //     itemBuilder: (context, index) {
                  //       final item = _items[index];
                  //       //print(_items[index]);
                  //       return Text(item.toString());
                  //     },
                  //   ),
                  // ),
                ],
              ),
      ),
    );
  }
}
