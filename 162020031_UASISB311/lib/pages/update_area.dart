// ignore_for_file: non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new, use_build_context_synchronously

import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';

import 'package:flutter/material.dart';
import 'package:uas_application/models/area_model.dart';

import 'package:uas_application/restapi.dart';

class AreaUpdate extends StatefulWidget {
  const AreaUpdate({super.key});

  @override
  State<AreaUpdate> createState() => _AreaUpdateState();
}

class _AreaUpdateState extends State<AreaUpdate> {
  final formKey = new GlobalKey<FormState>();

  TextEditingController area = TextEditingController();

  DataService ds = DataService();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List<String>;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 24, 11, 38),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 76, 0, 111),
          title: const Center(
            child: Text('Update Area'),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Area
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  controller: area,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: 'Nama Area',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                )),
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
                      try {
                        bool response = await ds.updateId(
                            'area',
                            area.text,
                            '63476a7599b6c11c094bd4ff',
                            'site_inspector',
                            'area',
                            "63b6240abc64651ccd513b91",
                            args[0]);
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
}
