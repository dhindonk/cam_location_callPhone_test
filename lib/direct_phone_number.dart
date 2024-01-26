import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';

class CallPage extends StatefulWidget {
  const CallPage({Key? key}) : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late PermissionStatus? _permissionStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    _requestCallPermission();
  }

  Future<void> _requestCallPermission() async {
    final status = await Permission.phone.request();
    print('INI STATUS ---> $status');

    if (_permissionStatus == PermissionStatus.permanentlyDenied) {
      _showPermissionPermanentlyDeniedDialog();
    }
    setState(() {
      _permissionStatus = status;
    });
  }

  void _showPermissionPermanentlyDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Izin Panggilan Diperlukan'),
          content: Text(
              'Untuk menggunakan fitur panggilan, Anda perlu mengizinkan aplikasi untuk mengakses panggilan di pengaturan.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings(); // Buka pengaturan aplikasi
              },
              child: Text('Buka Pengaturan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (_permissionStatus == PermissionStatus.granted) {
                  FlutterPhoneDirectCaller.callNumber('+6285894110928');
                } else {
                  _requestCallPermission();
                }
              },
              child: Icon(
                Icons.call,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
