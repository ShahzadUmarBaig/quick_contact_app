import 'package:call_log/call_log.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_chat/direct_dialogue.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Iterable<CallLogEntry> entries;
  List<CallLogEntry> entriesList;
  List<CallLogEntry> uniqueData;

  Future<List<CallLogEntry>> getCallLogs() async {
    entries = await CallLog.get();
    entriesList = entries.toList();
    final existing = Set<String>();

    uniqueData =
        entriesList.where((element) => existing.add(element.number)).toList();

    return uniqueData;
  }

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
  void initState() {
    super.initState();
    getCallLogs();
  }

  Widget getTitle(CallLogEntry data) {
    if (data.name == null) {
      return Text(
        "Unknown Number",
        style: TextStyle(
          color: Colors.black87,
          fontSize: 15,
        ),
      );
    } else {
      return Text(
        data.name,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 15,
        ),
      );
    }
  }

  getTileColor(CallLogEntry data) {
    if (data.name == null) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black54,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ShowTextDialog();
                },
              );
            },
          )
        ],
      ),
      body: FutureBuilder<List<CallLogEntry>>(
        future: getCallLogs(),
        builder: (context, AsyncSnapshot<List<CallLogEntry>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) =>
                  _customCard(callLogEntry: snapshot.data[index]),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _customCard({@required CallLogEntry callLogEntry}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      height: 70,
      child: Card(
        elevation: 4,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: getTileColor(callLogEntry),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      topLeft: Radius.circular(8))),
              child: SizedBox(
                height: double.infinity,
                width: 4,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getTitle(callLogEntry),
                  SizedBox(height: 4),
                  Text(
                    callLogEntry.number,
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: IconButton(
                  icon: Icon(
                    FontAwesomeIcons.whatsapp,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    _launchURL(callLogEntry.number);
                  }),
            )
          ],
        ),
      ),
    );
  }
}
