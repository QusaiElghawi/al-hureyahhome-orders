

import 'package:flutter/material.dart';

showLoading(BuildContext context){
  return showDialog(context: context, builder: (context){
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white10,
      child: AlertDialog(

        title: Text('Please Wait'),
        content: Container(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  });
}