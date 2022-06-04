import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:service_mobil_mobile/halaman/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Akun extends StatefulWidget {
  Akun({Key? key}) : super(key: key);

  @override
  State<Akun> createState() => _AkunState();
}

class _AkunState extends State<Akun> {
  Dio dio = Dio();
  List akun = [];

  TextEditingController namaController = TextEditingController();
  TextEditingController nomorController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  getAkun() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var nama = _pref.getString("nama");
    var idUser = _pref.getInt("id_user");
    var password = passwordController.text;

    var form = FormData.fromMap({
      "idUser": idUser,
    });

    final response = await dio
        .post("https://bengkel.famenarakudus.com/api/dataDiri", data: form);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.data);
      setState(() {
        // akun.addAll(response.data['data']);
        namaController.text = data['nm_pelanggan'];
        nomorController.text = data['no_pelanggan'];
        alamatController.text = data['alamat'];
      });
    }
  }

  postUpdate() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var idUser = _pref.getInt("id_user");
    var password = passwordController.text;
    var form = FormData.fromMap({
      "id_user": idUser,
      "nm_pelanggan": namaController.text,
      "no_telephone": nomorController.text,
      "alamat": alamatController.text,
      "password": password,
    });
    final res = await dio.post("https://bengkel.famenarakudus.com/api/ubahDiri",
        data: form);

    print(res.data);
  }

  @override
  void initState() {
    super.initState();
    getAkun();
  }

  @override
  Widget build(BuildContext context) {
    var password;
    return Scaffold(
      appBar: AppBar(
        title: Text('Akun Pengguna'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Image.asset(
              'assets/user.png',
              height: 120,
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: namaController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Nama Lengkap'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: nomorController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Nomor Telephone'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: alamatController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Alamat Anda'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: password,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Password Baru'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 65, 110, 224), // background
                onPrimary: Color.fromARGB(255, 255, 255, 255), // foreground
              ),
              onPressed: () {
                postUpdate();
              },
              child: Text('Ubah Data',
                  style: TextStyle(
                    fontSize: 17,
                  )),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 240, 62, 62), // background
                onPrimary: Color.fromARGB(255, 255, 255, 255), // foreground
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Login()));
              },
              child: Text(
                'Keluar Aplikasi',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
