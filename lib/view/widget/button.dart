import 'package:alhureyah_customer_service/view/themes.dart';
import 'package:flutter/material.dart';


class AppButton extends StatelessWidget {
  const AppButton({Key? key, required this.textButton,required this.onPressed}) : super(key:key);
  final String? textButton;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: const ButtonStyle(

            backgroundColor: MaterialStatePropertyAll<Color>(bluishClr),
            fixedSize: MaterialStatePropertyAll<Size>(Size.fromWidth(250)),


          ),
          child:  Text(textButton!,style: const TextStyle(color: Colors.white,fontSize: 20),),
        ),
      ],
    );
  }
}
