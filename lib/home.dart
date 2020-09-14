import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'api/api_call.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MainHomeApp());
}

class MainHomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dog List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainHomePage(),
    );
  }
}

List<dynamic> dogApiList = new List();
Map<dynamic, dynamic> dogsList = new Map();
String dogImage = "";
var popupDogDialog;

bool showLoader = false;

class MainHomePage extends StatefulWidget {
  MainHomePage();

  final String title = "Dog List";

  @override
  MyMainHomPageState createState() => MyMainHomPageState();
}

class MyMainHomPageState extends State<MainHomePage>
    with WidgetsBindingObserver {
  AppLifecycleState _lastLifecycleState;
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    makeRequest();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    BackButtonInterceptor.remove(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }

  makeRequest() async {
    try {
      if (checkNetwork() != null) {
        apiDogsList = await getDogs();
        for (final name in apiDogsList.keys) {
          setState(() {
            dogApiList.add(name);
          });
        }
      }
    } catch (error) {
      print("makeRequestException $error");
    }
  }

  getDogPicture(dogName) async {
    try {
      if (checkNetwork() != null) {
        await getDogPictureUrl(dogName);
        if (dogImageUrl != null) {
          showDogCard(dogName, dogImageUrl);
        }
      }
    } catch (error) {
      print("getDogPictureException $error");
    }
  }

  showDogCard(String dogName, String dogImageUrl) async {
    Size size = MediaQuery.of(context).size;
    var screenWidth = size.width;

    popupDogDialog = await showDialog(
        context: context,
        barrierDismissible: true,
        child: new SimpleDialog(
          contentPadding: EdgeInsets.all(6.0),
          titlePadding: EdgeInsets.all(4.0),
          elevation: 4.0,
          title: Container(
            padding: EdgeInsets.all(4.0),
            color: Colors.blueAccent,
            child: new Text(
              dogName,
              style: GoogleFonts.montserrat(
                fontSize: 25.0,
                textStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                //color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.network(dogImageUrl,
                  height: 240, width: screenWidth, fit: BoxFit.fill),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      Text("Close"),
                    ],
                  ),
                  textColor: Colors.white,
                  color: Colors.black12,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dog List'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                makeRequest();
              },
            ),
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Column(children: <Widget>[
            if (dogApiList == null)
              Container(
                child: Center(
                  child: Loading(
                      indicator: BallPulseIndicator(),
                      size: 100.0,
                      color: Colors.blueAccent),
                ),
              ),
            if (dogApiList != null)
              Expanded(
                child: Container(
                  padding: new EdgeInsets.all(16.0),
                  child: ListView.separated(
                    itemCount: dogApiList == null ? 0 : dogApiList.length,
                    itemBuilder: (BuildContext context, i) {
                      return Card(
                          child: ListTile(
                        title: new Text(dogApiList[i],
                            style: new TextStyle(
                              color: Colors.black,
                            )),
                        trailing: Icon(
                          Icons.navigate_next,
                          color: Colors.black,
                        ),
                        onTap: () {
                          getDogPicture(dogApiList[i].toString());
                        },
                      ));
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                ),
              ),
          ]),
        ));
  }
}
