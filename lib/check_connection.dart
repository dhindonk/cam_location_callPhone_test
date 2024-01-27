import 'package:camera_location/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Future<void> main() async {
//   runApp(const MyApp());
//   DependencyInjection.init();
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Network Cek',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const CekKoneksi(),
//     );
//   }
// }

class CekKoneksi extends StatefulWidget {
  const CekKoneksi({super.key});

  @override
  State<CekKoneksi> createState() => _CekKoneksiState();
}

class _CekKoneksiState extends State<CekKoneksi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CEK KONEKSI'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('PAGE 1'),
          ElevatedButton(
              onPressed: () => Get.to(() => Page2()), child: Text('Gas'))
        ],
      )),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PAGE 2'),
        centerTitle: true,
        elevation: 0,
      ),
      body: const Center(
          child: Text('GA ADA APA APA CUMA TES STATUS INTERNET AJA')),
    );
  }
}
