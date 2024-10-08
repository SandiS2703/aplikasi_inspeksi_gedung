// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:uas_application/models/area_model.dart';
import 'package:uas_application/models/inspection_model.dart';
import 'package:flutter/material.dart';
import 'package:uas_application/models/user_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:uas_application/restapi.dart';

class InspectionList extends StatefulWidget {
  const InspectionList({super.key});

  @override
  InspectionListState createState() => InspectionListState();
}

class InspectionListState extends State<InspectionList> {
  late UserModel userLogin;
  List<InspectionModel> inspec = [];
  List dtInspection = [];
  DataService ds = DataService();

  @override
  void initState() {
    //selectAllInspection(args[0]);
    super.initState();
  }

  selectAllInspection(String area) async {
    dtInspection = jsonDecode(await ds.selectWhereLike(
        '63476a7599b6c11c094bd4ff',
        'site_inspector',
        'inspection',
        '63b6240abc64651ccd513b91',
        'area',
        area));
    inspec = dtInspection.map((e) => InspectionModel.fromJson(e)).toList();
    if (this.mounted) {
      setState(() {
        inspec = inspec;
      });
    }
  }

  FutureOr reloadDataIns(dynamic value) {
    final args2 = ModalRoute.of(context)?.settings.arguments as List<String>;
    if (this.mounted) {
      setState(() {
        selectAllInspection(args2[0]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List<String>;

    reloadDataIns(args[0]);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 24, 11, 38),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushNamed(context, 'area',
              arguments: [args[1], args[2]]),
        ),
        backgroundColor: Color.fromARGB(255, 76, 0, 111),
        title: const Center(
          child: Text('Inspection List'),
        ),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'add',
                      arguments: [args[0], args[1], args[2]]);
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
                print(inspec.length);
              },
              child: const Icon(
                Icons.search,
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
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(''),
                                  // Area
                                  Text(item.area,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25)),
                                  Text(''),
                                  // Notes
                                  Text(
                                      'Catatan Inspeksi : ' +
                                          item.notes_inspection,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15)),
                                  Text(''),
                                  // Date
                                  Text(
                                      'Tanggal Inspeksi : ' +
                                          item.date_inspection,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15)),
                                  Text(''),
                                  //Time
                                  Text('Jam Inspeksi : ' + item.time_inspection,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15)),
                                  Text(''),
                                  Text('Status : ' + item.status,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15)),
                                ],
                              ))
                        ],
                      ),
                    ])),
                onTap: () {
                  Navigator.pushNamed(context, 'detail', arguments: [item.id])
                      .then(reloadDataIns);
                },
              ));
        },
      ),
    );
  }
}
