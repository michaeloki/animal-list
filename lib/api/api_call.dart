import 'dart:convert';
import 'dart:io';
import 'package:animal_inventory/utils/toast_widget.dart';
import 'package:http/http.dart';

String baseUrl = "https://dog.ceo";
bool networkStatus = false;
Map<dynamic, dynamic> apiDogsList = new Map();
Map<dynamic, dynamic> apiDogsImage = new Map();
var decodedDogImage;
String dogImageUrl;

Future<bool> checkNetwork() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      networkStatus = true;
    }
  } on SocketException catch (_) {
    ToastWidget().ShowToast("Please check your network", "long");
  }
  return networkStatus;
}

getDogs() async {
  Response response = await get(baseUrl + "/api/breeds/list/all",
      headers: {"Content-type": "application/json"});
  if (response.statusCode == 200) {
    try {
      final apiResponse = json.decode(response.body) as Map;
      if (apiResponse["status"].toString().toLowerCase().contains("success")) {
        final decodedDogs = apiResponse["message"] as Map;
        return decodedDogs;
      }
    } catch (error) {
      ToastWidget().ShowToast(error.toString(), "long");
    }
  } else {
    ToastWidget().ShowToast(response.body, "long");
  }
}

getDogPictureUrl(String dogName) async {
  Response response = await get(baseUrl + "/api/breed/$dogName/images/random",
      headers: {"Content-type": "application/json"});
  if (response.statusCode == 200) {
    try {
      final apiResponse = json.decode(response.body);
      if (apiResponse["status"].toString().toLowerCase().contains("success")) {
        dogImageUrl = apiResponse["message"].toString();
        return dogImageUrl;
      }
    } catch (error) {
      ToastWidget().ShowToast(error, "long");
    }
  } else {
    ToastWidget().ShowToast(response.body, "long");
  }
}
