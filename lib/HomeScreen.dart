import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
    var whatsAppUrl = "whatsapp://send?phone=$phone";
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
