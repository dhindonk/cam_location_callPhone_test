import 'package:camera_location/camera_location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'dependency_injection.dart';
import 'direct_phone_number.dart';

void main() async {
  await initializeDateFormatting('id_ID', null);
  DependencyInjection.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: ImagePickers(),
    );
  }
}