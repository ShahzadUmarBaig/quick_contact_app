import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_chat/main.dart';

class PermissionPage extends StatefulWidget {
  @override
  _PermissionPageState createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  bool isLoaded = true;

  getPermission() async {
    setState(() {
      isLoaded = false;
    });

    if (await Permission.phone.request().isGranted) {
      return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyApp(
            status: true,
          ),
        ),
      );
    } else {
      setState(() {
        isLoaded = true;
      });
    }
  }

  double getTextFontSize(ratio) {
    if (ratio < 2) {
      return 16.0;
    } else {
      return 18.0;
    }
  }

  double getButtonFontSize(ratio) {
    if (ratio < 2) {
      return 16.0;
    } else {
      return 18.0;
    }
  }

  double getPermissionFontSize(ratio) {
    if (ratio < 2) {
      return 16.0;
    } else {
      return 18.0;
    }
  }

  double getEmojiFontSize(ratio) {
    if (ratio < 2) {
      return 20.0;
    } else {
      return 24.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoaded
          ? Center(
              child: Container(
                height: MediaQuery.of(context).size.height / 4.5,
                width: MediaQuery.of(context).size.width - 50,
                child: Card(
                  elevation: 4,
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "This app requires permissions to your phone logs, to grant permission press the request button and enjoy the app",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              fontSize: 14, color: Colors.white),
                        ),
                        Spacer(),
                        FlatButton(
                          onPressed: getPermission,
                          child: Text(
                            "Request",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                                fontSize: 14, color: Colors.red),
                          ),
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 128),
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(height: 24),
                  Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "PLEASE GRANT PERMISSION",
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "☹",
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
