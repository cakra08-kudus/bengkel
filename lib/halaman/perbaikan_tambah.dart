import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:service_mobil_mobile/halaman/perbaikan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerbaikanTambah extends StatefulWidget {
  PerbaikanTambah({Key? key}) : super(key: key);

  @override
  State<PerbaikanTambah> createState() => _PerbaikanTambahState();
}

class _PerbaikanTambahState extends State<PerbaikanTambah> {
  Dio dio = Dio();

  TextEditingController pembawaKendaraan = TextEditingController();
  TextEditingController kilometerKendaraan = TextEditingController();
  TextEditingController keluhanKendaraan = TextEditingController();

  @override
  DateTime? selectedDate = DateTime.now();

  final jasa_services = ['Booking Service', 'Home Service'];
  String? selectedPilihan;

  final kendaraan = [];
  String? selectedKendaraan;

  getKendaraan() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var idUser = _pref.getInt("id_user");

    var form = FormData.fromMap({
      "id_user": idUser,
    });

    final response = await dio
        .post("https://bengkel.famenarakudus.com/api/tampilGarasi", data: form);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.data);
      setState(() {
        kendaraan.addAll(data);
      });
      print(kendaraan);
    }
  }

  final jasa = [];
  String? selectedJasa;

  getJasa() async {
    try {
      final response =
          await dio.get("https://bengkel.famenarakudus.com/api/jasa");
      print(response.data);
      if (response.statusCode == 200) {
        var data = response.data;
        setState(() {
          jasa.addAll(data['data']);
        });
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }

  tambah() async {
    var pembawa = pembawaKendaraan.text;
    var kilometer = kilometerKendaraan.text;
    var keluhan = keluhanKendaraan.text;

    var form = FormData.fromMap({
      "id_kendaraan": selectedKendaraan,
      "id_jasa": selectedJasa,
      "tgl_service": selectedDate,
      "pilihan_service": selectedPilihan,
      "pembawa_kendaraan": pembawa,
      "keluhan": keluhan,
      "kilometer": kilometer,
    });

    final res = await dio.post(
        "https://bengkel.famenarakudus.com/api/tambahService",
        data: form);

    if (res.statusCode == 200) {
      print("Berhasil Simpan");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Perbaikan()));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Berhasil Simpan Data')));
    }
  }

  @override
  void initState() {
    super.initState();
    getKendaraan();
    getJasa();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Service'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              )),
              hint: Text("Pilih Kendaraan Anda"),
              value: selectedKendaraan,
              items: kendaraan
                  .map((row) => DropdownMenuItem<String>(
                        value: row['id_kendaraan_pelanggan'],
                        child: Text(
                          row['merek_kendaraan'],
                          style: const TextStyle(fontSize: 20),
                        ),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => selectedKendaraan = val),
            ),
            SizedBox(
              height: 20,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              )),
              hint: Text("Pilih Tipe Jasa Service"),
              value: selectedPilihan,
              items: jasa_services
                  .map((row) => DropdownMenuItem(
                        value: row,
                        child: Text(
                          row,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => selectedPilihan = val),
            ),
            SizedBox(
              height: 20,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              )),
              hint: Text("Pilih Jasa Service"),
              value: selectedJasa,
              items: jasa
                  .map((row) => DropdownMenuItem<String>(
                        value: row['id_jasa'],
                        child: Text(
                          row['nm_jasa'],
                          style: const TextStyle(fontSize: 18),
                        ),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => selectedJasa = val),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tanggal Service",
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      DateFormat("yyyy-MM-dd").format(selectedDate!),
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: pembawaKendaraan,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Pembawa Kendaraan'),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: kilometerKendaraan,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Kilometer Kendaraan'),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: keluhanKendaraan,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintText: 'Keluhan Kendaraan Anda'),
              maxLines: 10,
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 65, 110, 224), // background
                onPrimary: Color.fromARGB(255, 255, 255, 255), // foreground
              ),
              onPressed: () {
                // proses simpan
                tambah();
              },
              child: Text('Simpan Data', style: TextStyle(fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
