// ignore_for_file: non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uas_application/models/area_model.dart';
import 'package:uas_application/models/gallery_model.dart';
import 'package:uas_application/models/inspection_model.dart';
import 'package:uas_application/restapi.dart';
import 'package:uas_application/utils/validator.dart';

class InspectionAdd extends StatefulWidget {
  const InspectionAdd({super.key});

  @override
  State<InspectionAdd> createState() => _InspectionAddState();
}

class _InspectionAddState extends State<InspectionAdd> {
  final formKey = new GlobalKey<FormState>();
  final date_inspecsion = TextEditingController();
  final time_inspection = TextEditingController();
  final notes_inspection = TextEditingController();
  final date_fix = TextEditingController();
  final time_fix = TextEditingController();
  final notes_fix = TextEditingController();
  final user_id_fix = TextEditingController();
  final user_name_fix = TextEditingController();
  final status = TextEditingController();

  late Future<DateTime?> selectedDate;
  File? image;
  String? imageProfpic;
  String date = "-";
  //String Area = "";
  String Status = "";
  TimeOfDay timeOfDay = TimeOfDay.now();
  DataService ds = DataService();
  List<InspectionModel> ins = [];
  List<GalleryModel> gl = [];
  List data = [];

  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context)?.settings.arguments as UserModel;
    final args = ModalRoute.of(context)?.settings.arguments as List<String>;
    //selectAll();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 24, 11, 38),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 76, 0, 111),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, 'list',
              arguments: [args[0], args[1], args[2]]),
        ),
        title: const Text("Add Data Inspection"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 9),
                      child: Text('Area : ' + args[0],
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 9),
                      child: TextFormField(
                        controller: notes_inspection,
                        validator: (value) => Validator.validateName(
                          name: value,
                        ),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintText: "Notes",
                          hintStyle: TextStyle(color: Colors.white),
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 9),
                      child: TextFormField(
                        controller: date_inspecsion,
                        validator: (value) => Validator.validateName(
                          name: value,
                        ),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintText: "Date",
                          hintStyle: TextStyle(color: Colors.white),
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                        onTap: () {
                          showDialogPicker(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 9),
                      child: TextFormField(
                        controller: time_inspection,
                        validator: (value) => Validator.validateName(
                          name: value,
                        ),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintText: "Time",
                          hintStyle: TextStyle(color: Colors.white),
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                        onTap: () {
                          displayTimePicker(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 9),
                      child: Text('ID : ' + args[1],
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 9),
                      child: Text('Username : ' + args[2],
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                    ),
                    DropdownButtonFormField(
                      //style: BoxDecoration()
                      items: <String>['', 'Belum Di Fix', 'Sudah Di Fix']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (kDebugMode) {
                          print(newValue);
                        }

                        setState(() {
                          Status = newValue!;
                        });
                      },
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        filled: false,
                        border: InputBorder.none,
                      ),
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                          dropdownColor: Color.fromARGB(255, 24, 11, 38),
                      value: Status,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 8, vertical: 9),
                    //   child: TextFormField(
                    //     controller: status,
                    //     validator: (value) => Validator.validateName(
                    //       name: value,
                    //     ),
                    //     decoration: InputDecoration(
                    //       hintText: "Status",
                    //       errorBorder: UnderlineInputBorder(
                    //         borderRadius: BorderRadius.circular(6.0),
                    //         borderSide: const BorderSide(
                    //           color: Colors.red,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () async {
                                  List response = jsonDecode(
                                      await ds.insertInspection(
                                          "63b6240abc64651ccd513b91",
                                          args[0],
                                          date_inspecsion.text,
                                          time_inspection.text,
                                          notes_inspection.text,
                                          args[1],
                                          args[2],
                                          "-",
                                          "-",
                                          "-",
                                          "-",
                                          "-",
                                          Status));
                                  List<InspectionModel> inspection = response
                                      .map((e) => InspectionModel.fromJson(e))
                                      .toList();

                                  if (inspection.length == 1) {
                                    Navigator.pushNamed(context, 'list',
                                        arguments: [args[0], args[1], args[2]]);
                                  } else {
                                    if (kDebugMode) {
                                      print(response);
                                    }
                                  }
                                },
                                child: const Text("Add Data"))),
                        SizedBox(width: 24.0),
                      ],
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void showDialogPicker(BuildContext context) {
    selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1998),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );

    selectedDate.then((value) {
      setState(() {
        if (value == null) return;

        final DateFormat formatter = DateFormat('dd-MMM-yyyy');
        final String formattedDate = formatter.format(value);
        date_inspecsion.text = formattedDate;
      });
    }, onError: (error) {
      if (kDebugMode) {
        print(error);
      }
    });
  }

  Future displayTimePicker(BuildContext context) async {
    var time = await showTimePicker(context: context, initialTime: timeOfDay);

    if (time != null) {
      setState(() {
        time_inspection.text = "${time.hour}:${time.minute}";
      });
    }
  }
}
