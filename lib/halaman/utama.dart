import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:service_mobil_mobile/halaman/akun.dart';
import 'package:service_mobil_mobile/halaman/garasi.dart';
import 'package:service_mobil_mobile/halaman/home.dart';
import 'package:service_mobil_mobile/halaman/perbaikan.dart';

class Utama extends StatefulWidget {
  Utama({Key? key}) : super(key: key);

  @override
  State<Utama> createState() => _UtamaState();
}

class _UtamaState extends State<Utama> {
  int selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        Home(),
        Garasi(),
        Perbaikan(),
        Akun(),
      ][selectedPage],
      bottomNavigationBar: ConvexAppBar(
          style: TabStyle.react,
          items: const [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.emoji_transportation, title: 'Garasi'),
            TabItem(icon: Icons.calendar_today, title: 'Service'),
            TabItem(icon: Icons.person, title: 'Akun'),
          ],
          initialActiveIndex: 0,
          // onTap: (int i) => print('click index=$i'),
          onTap: (int i) {
            setState(() {
              selectedPage = i;
            });
          }),
    );
  }
}
