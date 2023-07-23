import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../themes.dart';

class InputField extends StatelessWidget {
   InputField(
      {Key? key,
        this.validate,
        required this.title,
        required this.hint,
        this.controller,
        this.widget, this.isPassword, this.onSave})
      : super(key: key);

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  final bool? isPassword;
  final String Function(String? val)? validate;
  final Function(String? val)? onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Themes().titleHeadingStyle,
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            //margin: EdgeInsets.all(5),
            width: double.infinity,
            height: 52,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    validator: validate,
                    onSaved: onSave,
                    controller: controller,
                    obscureText: isPassword ?? false,
                    autofocus: false,
                    readOnly: widget != null ?false:true,
                    cursorColor:
                    Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                    style: Themes().subTitleHeadingStyle,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: Themes().subTitleHeadingStyle,
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 0, color: context.theme.backgroundColor)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 0, color: context.theme.backgroundColor)),
                    ),
                  ),
                ),
                widget ?? Container()
              ],
            ),
          )
        ],
      ),
    );
  }
}
