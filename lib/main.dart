import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_chat/PermissionPage.dart';

import 'HomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var status = await Permission.phone.isGranted;
  runApp(MyApp(status: status));
}

class MyApp extends StatelessWidget {
  final status;

  const MyApp({Key key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quick Contact',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:
          status ? MyHomePage(title: 'Message On WhatsApp') : PermissionPage(),
    );
  }
}
