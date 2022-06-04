import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:service_mobil_mobile/halaman/login.dart';

class Registrasi extends StatefulWidget {
  Registrasi({Key? key}) : super(key: key);

  @override
  State<Registrasi> createState() => _RegistrasiState();
}

class _RegistrasiState extends State<Registrasi> {
  Dio dio = Dio();

  TextEditingController namaLengkapController = TextEditingController();
  TextEditingController nomorTelephoneController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  simpan() async {
    var nama = namaLengkapController.text;
    var nomor = nomorTelephoneController.text;
    var alamat = alamatController.text;
    var password = passwordController.text;

    try {
      var form = FormData.fromMap({
        "nm_pelanggan": nama,
        "alamat": alamat,
        "no_pelanggan": nomor,
        "password": password,
      });

      final res = await dio
          .post("https://bengkel.famenarakudus.com/api/pelanggan", data: form);

      if (res.statusCode == 200) {
        print("Berhasil Simpan");
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Berhasil Membuat Akun')));
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrasi Akun'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              'Registrasi Akun Pelanggan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: namaLengkapController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Nama Lengkap'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: nomorTelephoneController,
              keyboardType: TextInputType.phone,
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
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Password'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 65, 110, 224), // background
                onPrimary: Color.fromARGB(255, 255, 255, 255), // foreground
              ),
              onPressed: () {
                simpan();
              },
              child: Text(
                'Daftar Akun Pelanggan',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Sudah Punya Akun ?",
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
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Login Sistem",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                // ,
              ],
            )
          ],
        ),
      ),
    );
  }
}
