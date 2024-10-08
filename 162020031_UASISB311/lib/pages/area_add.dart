// ignore_for_file: non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new, use_build_context_synchronously

import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';

import 'package:flutter/material.dart';
import 'package:uas_application/models/area_model.dart';

import 'package:uas_application/restapi.dart';

class AreaAdd extends StatefulWidget {
  const AreaAdd({super.key});

  @override
  State<AreaAdd> createState() => _AreaAdddState();
}

class _AreaAdddState extends State<AreaAdd> {
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
            child: Text('Tambahkan Area'),
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
                    hintText: 'Area',
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
                            title: "Tambahkan data??",
                            confirmButtonText: "Ya..",
                            type: ArtSweetAlertType.warning));

                    if (response == null) {
                      return;
                    }

                    if (response.isTapConfirmButton) {
                      try {
                        List response = jsonDecode(await ds.insertArea(
                            "63b6240abc64651ccd513b91", area.text));
                        List<AreaModel> data =
                            response.map((e) => AreaModel.fromJson(e)).toList();
                        if (data.length == 1) {
                          ArtDialogResponse response = await ArtSweetAlert.show(
                              context: context,
                              barrierDismissible: false,
                              artDialogArgs: ArtDialogArgs(
                                  type: ArtSweetAlertType.success,
                                  title: "Data Berhasil Ditambahkan!",
                                  confirmButtonText: "OK"));
                          if (response == null) {
                            return;
                          }

                          if (response.isTapConfirmButton) {
                            Navigator.pushNamed(context, 'area', arguments: [args[0], args[1]]);
                          }
                        }
                      } catch (e) {
                        ArtDialogResponse response = await ArtSweetAlert.show(
                            barrierDismissible: false,
                            context: context,
                            artDialogArgs: ArtDialogArgs(
                                title: 'Data Gagal Ditambahkan!',
                                confirmButtonText: "OK",
                                type: ArtSweetAlertType.warning));
                        if (response == null) {
                          return;
                        }

                        if (response.isTapConfirmButton) {
                          setState(() {});
                        }
                      }
                    }
                  },
                  child: const Text("SUBMIT"),
                ),
              ),
            )
          ],
        ));
  }
}
