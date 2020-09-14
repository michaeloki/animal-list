import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastWidget {
  ShowToast(message,myDuration) {
    Toast duration = Toast.LENGTH_SHORT;
    if(myDuration=="long") {
      duration = Toast.LENGTH_LONG;
    }
    Fluttertoast.showToast(
        msg: message,
        toastLength: duration,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
