import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:service_mobil_mobile/halaman/registrasi.dart';
import 'package:service_mobil_mobile/halaman/utama.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Dio dio = Dio();

  TextEditingController noTelpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login() async {
    var noTelp = noTelpController.text;
    var password = passwordController.text;

    try {
      var form = FormData.fromMap({
        "username": noTelp,
        "password": password,
      });

      final res = await dio.post("https://bengkel.famenarakudus.com/api/login",
          data: form);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.data);

        SharedPreferences _pref = await SharedPreferences.getInstance();

        _pref.setInt("id_user", data['id_user']);
        _pref.setString("nama", data['nama']);

        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Utama()));
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text('Berhasil Login')));
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(50),
        child: ListView(
          children: [
            Image.asset(
              'assets/car.png',
              height: 150,
            ),
            SizedBox(
              height: 50,
            ),
            TextField(
              controller: noTelpController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Nomor Telephone'),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Password Anda'),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 65, 110, 224), // background
                onPrimary: Color.fromARGB(255, 255, 255, 255), // foreground
              ),
              onPressed: () {
                login();
              },
              child: Text('Login Sistem'),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Belum Punya Akun ?",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Registrasi()));
                  },
                  child: const Text(
                    "Daftar Akun",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
