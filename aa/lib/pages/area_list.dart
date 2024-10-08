// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:uas_application/models/area_model.dart';
import 'package:uas_application/models/inspection_model.dart';
import 'package:flutter/material.dart';
import 'package:uas_application/models/user_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:uas_application/restapi.dart';

class AreaList extends StatefulWidget {
  const AreaList({super.key});

  @override
  AreaListState createState() => AreaListState();
}

class AreaListState extends State<AreaList> {
  List<AreaModel> inspec = [];
  List dtInspection = [];
  DataService ds = DataService();

  @override
  void initState() {
    selectAllIArea();
    super.initState();
  }

  selectAllIArea() async {
    dtInspection = jsonDecode(await ds.selectAll('63476a7599b6c11c094bd4ff',
        'site_inspector', 'area', '63b6240abc64651ccd513b91'));
    inspec = dtInspection.map((e) => AreaModel.fromJson(e)).toList();
    setState(() {
      inspec = inspec;
    });
  }

  FutureOr reloadDataArea(dynamic value) {
    setState(() {
      selectAllIArea();
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List<String>;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 24, 11, 38),
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () async {
              ArtDialogResponse response = await ArtSweetAlert.show(
                  barrierDismissible: false,
                  context: context,
                  artDialogArgs: ArtDialogArgs(
                      denyButtonText: "Tidak..",
                      title: "Apakah anda yakin ingin logout??",
                      confirmButtonText: "Ya..",
                      type: ArtSweetAlertType.warning));

              if (response == null) {
                return;
              }

              if (response.isTapConfirmButton) {
                ArtDialogResponse response = await ArtSweetAlert.show(
                  barrierDismissible: false,
                  context: context,
                  artDialogArgs: ArtDialogArgs(
                      title: "Berhasil Logout",
                      confirmButtonText: "OK",
                      type: ArtSweetAlertType.success));

                if (response == null) {
                  return;
                }

                if (response.isTapConfirmButton) {
                  Navigator.pushNamed(context, 'login');
                  return;
                }
              }
            }),
        backgroundColor: Color.fromARGB(255, 76, 0, 111),
        title: const Center(
          child: Text('Area List'),
        ),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'area_add');
                },
                child: const Icon(
                  Icons.add,
                  size: 26.0,
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Warning"),
                      content: const Text("Remove this data?"),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('CANCEL'),
                          onPressed: () {
                            // Close Dialog
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('REMOVE'),
                          onPressed: () async {
                            // Close Dialog
                            Navigator.pushNamed(context, 'area');

                            bool response = await ds.removeId(
                                '63476a7599b6c11c094bd4ff',
                                'site_inspector',
                                'area',
                                '63b6240abc64651ccd513b91',
                                inspec[0].id);

                            if (response) {
                              Navigator.pop(context, true);
                            }
                          },
                        )
                      ],
                    );
                  },
                );
              },
              child: const Icon(
                Icons.delete_outline,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: inspec.length,
        itemBuilder: (context, index) {
          final item = inspec[index];
          return Container(
              height: 200,
              child: GestureDetector(
                child: Card(
                    color: Color.fromARGB(255, 46, 40, 62),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.home_work,
                              color: Colors.white,
                              size: 130,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(''),
                                  // Area
                                  Text(item.area,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 30)),
                                ],
                              ))
                        ],
                      ),
                    ])),
                onTap: () {
                  Navigator.pushNamed(context, 'list',
                          arguments: [item.area, args[0], args[1]])
                      .then(reloadDataArea);
                },
              ));
        },
      ),
    );
  }
}
