import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as toast;

class Toast {
  static show(String text) {
    toast.Fluttertoast.showToast(
        msg: text,
        toastLength: toast.Toast.LENGTH_SHORT,
        gravity: toast.ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
