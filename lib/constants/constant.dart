
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Constants {

  static String apiKey = "7d79a0348d08945377e89a95cd670c5a";
  getDivider({required BuildContext context}) {
    return Container(
      color: Colors.grey.withOpacity(.2),
      height: 14,
    );
  }

  getThinDivider() {
    return Container(
      height: .5,
      width: double.infinity,
      color: Colors.grey.shade300.withOpacity(.5),
    );
  }

  getToast(String message) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,

        //    textColor: Colors.white,
        fontSize: 16.0);
  }

  getSnackBar({required BuildContext context, required String msg}) {
    final snackBar = SnackBar(content: Text(msg));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}

