import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:uas_application/restapi.dart';
import 'package:uas_application/utils/rounded_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:uas_application/models/user_model.dart';

//code for designing the UI of our text field where the user writes his email id or password

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late UserModel user_login;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool showSpinner = false;
  List<UserModel> _user = [];
  List data = [];
  DataService ds = DataService();

  selectAll() async {
    data = jsonDecode(await ds.selectAll('63476a7599b6c11c094bd4ff',
        'site_inspector', 'user', '63b6240abc64651ccd513b91'));
    _user = data.map((e) => UserModel.fromJson(e)).toList();
    setState(() {
      _user = _user;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //fetchData();
    selectAll();
  }

  @override
  Widget build(BuildContext context) {
    int user = 0;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("lib/images/login_background.jpg"),
                fit: BoxFit.cover)),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2.5,
              //child: Image.asset('lib/images/frame_burst_logo_dark.png'),
            ),
            Expanded(
              child: Container(
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Username',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black,
                          ),
                          child: TextField(
                            onChanged: (value) {
                              username.text = value;
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.white,
                              ),
                              hintText: 'Username',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Password',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black,
                          ),
                          child: TextField(
                            onChanged: (value) {
                              password.text = value;
                            },
                            obscureText: true,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                            decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        )),
                        const SizedBox(height: 8),
                        GestureDetector(
                          child: RoundedButton(
                            colour: Colors.black,
                            title: 'Log In',
                            onPressed: () async {
                              setState(() {
                                showSpinner = true;
                              });
                              try {
                                if (username.text == '' &&
                                    password.text == '') {
                                  ArtDialogResponse response =
                                      await ArtSweetAlert.show(
                                          barrierDismissible: false,
                                          context: context,
                                          artDialogArgs: ArtDialogArgs(
                                              title:
                                                  'Itu Kolom Tolong Diisi Dong!!',
                                              confirmButtonText: "OK",
                                              type: ArtSweetAlertType.warning));
                                  if (response == null) {
                                    return;
                                  }

                                  if (response.isTapConfirmButton) {
                                    setState(() {});
                                  }
                                } else if (username.text == '') {
                                  ArtDialogResponse response =
                                      await ArtSweetAlert.show(
                                          barrierDismissible: false,
                                          context: context,
                                          artDialogArgs: ArtDialogArgs(
                                              title: 'Isi Username Dong!!',
                                              confirmButtonText: "OK",
                                              type: ArtSweetAlertType.warning));
                                  if (response == null) {
                                    return;
                                  }

                                  if (response.isTapConfirmButton) {
                                    setState(() {});
                                  }
                                } else if (password.text == '') {
                                  ArtDialogResponse response =
                                      await ArtSweetAlert.show(
                                          barrierDismissible: false,
                                          context: context,
                                          artDialogArgs: ArtDialogArgs(
                                              title: 'Isi Passwordnya Dong!!',
                                              confirmButtonText: "OK",
                                              type: ArtSweetAlertType.warning));
                                  if (response == null) {
                                    return;
                                  }

                                  if (response.isTapConfirmButton) {
                                    setState(() {});
                                  }
                                } else {
                                  user = 0;
                                  _user.forEach((f) async {
                                    if ((f.username == this.username.text) &&
                                        (f.password == this.password.text)) {
                                          user = 0;
                                          user_login = f;
                                      ArtDialogResponse response =
                                          await ArtSweetAlert.show(
                                              context: context,
                                              barrierDismissible: false,
                                              artDialogArgs: ArtDialogArgs(
                                                  type:
                                                      ArtSweetAlertType.success,
                                                  title: "Login Berhasil!!",
                                                  confirmButtonText: "OK"));
                                      if (response == null) {
                                        return;
                                      }

                                      if (response.isTapConfirmButton) {
                                        Navigator.pushNamed(context, 'area', arguments: [f.id, f.name]);
                                      }
                                    }
                                    user++;
                                  });
                                  if (user != 0) {
                                    ArtDialogResponse response =
                                        await ArtSweetAlert.show(
                                            barrierDismissible: false,
                                            context: context,
                                            artDialogArgs: ArtDialogArgs(
                                                title: 'Register dulu kawan!!',
                                                confirmButtonText: "OK",
                                                type:
                                                    ArtSweetAlertType.warning));
                                    if (response == null) {
                                      return;
                                    }

                                    if (response.isTapConfirmButton) {
                                      setState(() {});
                                    }
                                  }
                                }
                              } catch (e) {
                                print(e);
                              }
                              setState(() {
                                showSpinner = false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 35),
                        const Center(
                          child: Text(
                            '- Or Sign In with -',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                ArtDialogResponse response =
                                    await ArtSweetAlert.show(
                                        barrierDismissible: false,
                                        context: context,
                                        artDialogArgs: ArtDialogArgs(
                                            type: ArtSweetAlertType.info,
                                            title:
                                                "Maaf Fitur Ini Belum Tersedia",
                                            confirmButtonText: "OK"));
                                if (response == null) {
                                  return;
                                }

                                if (response.isTapConfirmButton) {
                                  setState(() {});
                                }
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white38,
                                ),
                                child: Image.asset('lib/images/google.png'),
                              ),
                            ),
                            const SizedBox(width: 30),
                            GestureDetector(
                              onTap: () async {
                                // ArtDialogResponse response =
                                //     await ArtSweetAlert.show(
                                //         barrierDismissible: false,
                                //         context: context,
                                //         artDialogArgs: ArtDialogArgs(
                                //             type: ArtSweetAlertType.info,
                                //             title:
                                //                 "Maaf Fitur Ini Belum Tersedia",
                                //             confirmButtonText: "OK"));
                                // if (response == null) {
                                //   return;
                                // }

                                // if (response.isTapConfirmButton) {
                                //   setState(() {});
                                // }
                                Navigator.pushNamed(context, 'area');
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white38,
                                ),
                                child: Image.asset('lib/images/facebook.png'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Center(
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, 'register');
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ))),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
