import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowTextDialog extends StatelessWidget {
  final TextEditingController phoneController = new TextEditingController();

  _launchURL(String phone) async {
    var phoneNumber =
        phone.codeUnits.map((unit) => new String.fromCharCode(unit)).toList();
    String whatsAppUrl;
    String convertedPhone = "";
    if (phoneNumber.first == "+") {
      convertedPhone = phone;
    } else {
      phoneNumber.remove("0");
      phoneNumber.insert(0, "2");
      phoneNumber.insert(0, "9");
      phoneNumber.insert(0, "+");
      phoneNumber.forEach((element) {
        convertedPhone = convertedPhone + element;
      });
    }

    whatsAppUrl = "whatsapp://send?phone=$convertedPhone";

    if (await canLaunch(whatsAppUrl)) {
      await launch(whatsAppUrl);
    } else {
      throw 'Could not launch $whatsAppUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 60,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                controller: phoneController,
                enableInteractiveSelection: true,
                decoration: InputDecoration(
                  hintText: "03XXXXXXXXX",
                  hintStyle: GoogleFonts.montserrat(fontSize: 14),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                  border: InputBorder.none,
                ),
                toolbarOptions: ToolbarOptions(
                  paste: true,
                  cut: true,
                  copy: true,
                  selectAll: true,
                ),
                readOnly: false,
                focusNode: FocusNode(),
                autocorrect: false,
                autofocus: false,
              ),
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.clipboard),
              onPressed: () async {
                FlutterClipboard.paste().then((value) {
                  phoneController.text = value;
                });
              },
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.whatsapp),
              onPressed: () {
                if (phoneController.text.length != 11) {
                } else {
                  Navigator.pop(context);
                  _launchURL(phoneController.text);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
