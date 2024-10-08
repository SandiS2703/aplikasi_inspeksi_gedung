// ignore_for_file: non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uas_application/models/area_model.dart';
import 'package:uas_application/models/inspection_model.dart';
import 'package:uas_application/models/user_model.dart';

import 'package:uas_application/restapi.dart';
import 'package:uas_application/utils/validator.dart';

class InspectionUpdate extends StatefulWidget {
  const InspectionUpdate({super.key});

  @override
  State<InspectionUpdate> createState() => _InspectionUpdateState();
}

class _InspectionUpdateState extends State<InspectionUpdate> {
  final date_fix = TextEditingController();
  final time_fix = TextEditingController();
  final notes_fix = TextEditingController();
  final user_id_fix = TextEditingController();
  final user_name_fix = TextEditingController();
  String Status = '';
  late Future<DateTime?> selectedDate;

  String date = "-";
  TimeOfDay timeOfDay = TimeOfDay.now();
  DataService ds = DataService();
  List<InspectionModel> ins = [];
  List data = [];
  late UserModel userLogin;
  List<InspectionModel> inspec = [];
  List dtInspection = [];

  @override
  void initState() {
    //selectAllInspection(args[0]);
    super.initState();
  }

  final formKey = new GlobalKey<FormState>();

  TextEditingController area = TextEditingController();

  selectAllInspection(String id) async {
    dtInspection = jsonDecode(await ds.selectId('63476a7599b6c11c094bd4ff',
        'site_inspector', 'inspection', '63b6240abc64651ccd513b91', id));
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
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 24, 11, 38),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 76, 0, 111),
          title: const Center(
            child: Text('Update Inspection'),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Date Fix
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
              child: TextFormField(
                controller: date_fix,
                validator: (value) => Validator.validateName(
                  name: value,
                ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  hintText: "Date Fix",
                  hintStyle: TextStyle(color: Colors.white),
                  errorBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                  ),
                ),
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                onTap: () {
                  showDialogPicker(context);
                },
              ),
            ),
            //Time Fix
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
              child: TextFormField(
                controller: time_fix,
                validator: (value) => Validator.validateName(
                  name: value,
                ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  hintText: "Time Fix",
                  hintStyle: TextStyle(color: Colors.white),
                  errorBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                  ),
                ),
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                onTap: () {
                  displayTimePicker(context);
                },
              ),
            ),
            //Notes Fix
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
              child: TextFormField(
                controller: notes_fix,
                validator: (value) => Validator.validateName(
                  name: value,
                ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  hintText: "Notes Fix",
                  hintStyle: TextStyle(color: Colors.white),
                  errorBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                  ),
                ),
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
            //Id Fix
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
              child: Text('ID Fix : ' + args[1],
                  style: TextStyle(color: Colors.white, fontSize: 15)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
              child: Text('Name Fix : ' + args[2],
                  style: TextStyle(color: Colors.white, fontSize: 15)),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: DropdownButtonFormField(
                //style: BoxDecoration()
                items: <String>['', 'Belum Di Fix', 'Sudah Di Fix']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
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
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                dropdownColor: Color.fromARGB(255, 24, 11, 38),
                value: Status,
              ),
            ),
            //Submit Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple, elevation: 0),
                  onPressed: () async {
                    ArtDialogResponse response = await ArtSweetAlert.show(
                        barrierDismissible: false,
                        context: context,
                        artDialogArgs: ArtDialogArgs(
                            denyButtonText: "Tidak..",
                            title: "Update data??",
                            confirmButtonText: "Ya..",
                            type: ArtSweetAlertType.warning));

                    if (response == null) {
                      return;
                    }

                    if (response.isTapConfirmButton) {
                      print(args[3]);
                      try {
                        bool response = await ds.updateId(
                            'date_fix~time_fix~notes_fix~user_id_fix~user_name_fix~status',
                            '${date_fix.text}~${time_fix.text}~${notes_fix.text}~${user_id_fix.text}~${user_name_fix.text}~${Status}',
                            '63476a7599b6c11c094bd4ff',
                            'site_inspector',
                            'inspection',
                            "63b6240abc64651ccd513b91",
                            args[3]);
                        // List<AreaModel> data =
                        //     response.map((e) => AreaModel.fromJson(e)).toList();
                        if (response) {
                          ArtDialogResponse response = await ArtSweetAlert.show(
                              context: context,
                              barrierDismissible: false,
                              artDialogArgs: ArtDialogArgs(
                                  type: ArtSweetAlertType.success,
                                  title: "Data Berhasil Diupdate!",
                                  confirmButtonText: "OK"));
                          if (response == null) {
                            return;
                          }

                          if (response.isTapConfirmButton) {
                            Navigator.pushNamed(context, 'area',
                                arguments: [args[1], args[2]]);
                          }
                        }
                      } catch (e) {
                        ArtDialogResponse response = await ArtSweetAlert.show(
                            barrierDismissible: false,
                            context: context,
                            artDialogArgs: ArtDialogArgs(
                                title: 'Data Gagal Diupdate!',
                                confirmButtonText: "OK",
                                type: ArtSweetAlertType.warning));
                        print(e.toString());
                        if (response == null) {
                          return;
                        }

                        if (response.isTapConfirmButton) {
                          setState(() {});
                        }
                      }
                    }
                  },
                  child: const Text("Update"),
                ),
              ),
            )
          ],
        ));
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
        date_fix.text = formattedDate;
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
        time_fix.text = "${time.hour}:${time.minute}";
      });
    }
  }
}
