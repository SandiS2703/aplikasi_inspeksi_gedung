import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:uas_application/restapi.dart';
import 'package:uas_application/utils/rounded_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:uas_application/models/user_model.dart';
import 'package:uas_application/utils/validator.dart';

//code for designing the UI of our text field where the user writes his email id or password
const kTextFieldDecoration = InputDecoration(
    hintText: 'Enter a value',
    hintStyle: TextStyle(color: Colors.grey),
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromARGB(255, 255, 255, 255), width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromARGB(255, 255, 255, 255), width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ));

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final formKey = new GlobalKey<FormState>();
  final nama = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
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
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.lightBlueAccent,
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
                          'Nama',
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
                          child: TextFormField(
                            controller: nama,
                            validator: (value) => Validator.validateName(
                              name: value,
                            ),
                            
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              hintText: "Nama",
                              hintStyle: TextStyle(color: Colors.white),
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
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
                          child: TextFormField(
                            controller: username,
                            validator: (value) => Validator.validateUsername(
                              username: value,
                            ),
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.card_membership,
                                color: Colors.white,
                              ),
                              hintText: "Username",
                              hintStyle: TextStyle(color: Colors.white),
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
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
                          child: TextFormField(
                            obscureText: true,
                            controller: password,
                            validator: (value) => Validator.validatePassword(
                              password: value,
                            ),
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.white),
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
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
                              title: 'Register',
                              onPressed: () async {
                                //final field = _formkey.currentState;
                                ArtDialogResponse response =
                                    await ArtSweetAlert.show(
                                        barrierDismissible: false,
                                        context: context,
                                        artDialogArgs: ArtDialogArgs(
                                            denyButtonText: "Tidak..",
                                            title: "Lakukan Register??",
                                            confirmButtonText: "Ya..",
                                            type: ArtSweetAlertType.question));

                                if (response == null) {
                                  return;
                                }

                                if (response.isTapConfirmButton) {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  try {
                                    List response = jsonDecode(
                                        await ds.insertUser(
                                            '63b6240abc64651ccd513b91',
                                            nama.text,
                                            username.text,
                                            password.text));
                                    List<UserModel> user = response
                                        .map((e) => UserModel.fromJson(e))
                                        .toList();
                                    if (user.length == 1) {
                                      ArtDialogResponse response =
                                          await ArtSweetAlert.show(
                                              context: context,
                                              barrierDismissible: false,
                                              artDialogArgs: ArtDialogArgs(
                                                  type:
                                                      ArtSweetAlertType.success,
                                                  title: "Register Berhasil!",
                                                  confirmButtonText: "OK"));
                                      if (response == null) {
                                        return;
                                      }

                                      if (response.isTapConfirmButton) {
                                        Navigator.pushNamed(context, 'login');
                                      }
                                    }
                                  } catch (e) {
                                    ArtDialogResponse response =
                                        await ArtSweetAlert.show(
                                            barrierDismissible: false,
                                            context: context,
                                            artDialogArgs: ArtDialogArgs(
                                                title:
                                                    'Harap periksa email dan password yang anda tuliskan',
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
                                  setState(() {
                                    showSpinner = false;
                                  });
                                }
                              }),
                        ),
                        const SizedBox(height: 30),
                        Center(
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, 'login');
                                },
                                child: Text(
                                  'Log in',
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
