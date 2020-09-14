import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dog List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(title: 'Dog List'),
    );
  }
}

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation<double> animation;
  String appVersion;
  String appBuildNumber;

  openHomePage() {
    Navigator.of(context)
        .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
      return MainHomePage();
    }));
  }

  @override
  void initState() {
    super.initState();

    BackButtonInterceptor.add(myInterceptor);

    controller = new AnimationController(
        duration: new Duration(microseconds: 800), vsync: this);
    animation =
    new CurvedAnimation(parent: controller, curve: Curves.bounceOut);
    animation.addListener(() {
      this.setState(() {});
    });
    animation.addStatusListener((AnimationStatus status) {});
    controller.repeat();
    this.loadMainPage();
  }

  void loadMainPage() {
    Future.delayed(const Duration(milliseconds: 7000), () {
      openHomePage();
    });
  }


  @override
  void dispose() {
    super.dispose();
    BackButtonInterceptor.remove(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var screenHeight = size.height;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                  height: screenHeight * 0.90,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: double.infinity,
                            color: Colors.white,
                            child: AvatarGlow(
                              startDelay: Duration(milliseconds: 500),
                              glowColor: Colors.blueAccent,
                              endRadius: 100.0,
                              duration: Duration(milliseconds: 6000),
                              repeat: true,
                              showTwoGlows: true,
                              repeatPauseDuration: Duration(milliseconds: 100),
                              child: Material(
                                elevation: 8.0,
                                shape: CircleBorder(),
                                color: Colors.transparent,
                                child: CircleAvatar(
                                  backgroundImage:
                                  AssetImage('assets/images/animals.png'),
                                  radius: 50.0,
                                ),
                              ),
                              shape: BoxShape.circle,
                              animate: true,
                              curve: Curves.fastOutSlowIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              TextLiquidFill(
                text: 'Dog List',
                waveColor: Colors.blueAccent,
                boxBackgroundColor: Colors.white,
                textStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                boxHeight: screenHeight * 0.09,
              ),
            ],
          ),
        ),
      ),
    );
  }

}
