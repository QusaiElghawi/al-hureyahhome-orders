import 'package:alhureyah_customer_service/view/screen/home_screen.dart';
import 'package:alhureyah_customer_service/view/themes.dart';
import 'package:alhureyah_customer_service/view/widget/button.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/show_loading.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? myEmail;
  String? myPassword;
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  signIn() async {
    var formData = formState.currentState;
    if (formData!.validate()) {
      formData.save();
      try {
        showLoading(context);
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: myEmail!, password: myPassword!);
        return credential;
      } on FirebaseAuthException catch (e) {
        Get.back();
        if (e.code == 'user-not-found') {
          AwesomeDialog(
              context: context,
              title: 'Error',
              body: const Padding(
                padding: EdgeInsets.only(bottom: 20, top: 10),
                child: Text('No user found for that email.'),
              )).show();
        } else if (e.code == 'wrong-password') {
          AwesomeDialog(
              context: context,
              title: 'Error',
              body: const Padding(
                padding: EdgeInsets.only(bottom: 20, top: 10),
                child: Text('Wrong password provided for that user.'),
              )).show();
        }
      }
    }
  }

  FocusNode focusOne = FocusNode();
  FocusNode focusTow = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode focusScopeNode = FocusScope.of(context);
            if (!focusScopeNode.hasPrimaryFocus) {
              focusScopeNode.unfocus();
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: formState,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Image.asset(
                      'assets/images/hlogo.png',
                      width: 250,
                      height: 250,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Login",
                      style: Themes().headingStyle,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      focusNode: focusOne,
                      onFieldSubmitted: (val) {
                        FocusScope.of(context).requestFocus(focusTow);
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Email'),
                        suffixIcon: Icon(Icons.email_outlined),
                        hintText: 'Enter your Email',
                      ),
                      validator: (val) {
                        if (val!.length > 50) {
                          return 'Email is too long';
                        }
                        if (val.length < 10) {
                          return 'Email is too short';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        myEmail = val;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      focusNode: focusTow,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Password'),
                        suffixIcon: Icon(Icons.lock_open_outlined),
                        hintText: 'Enter your Password',
                      ),
                      obscureText: true,
                      validator: (val) {
                        if (val!.length > 100) {
                          return 'password is too long';
                        }
                        if (val.length < 8) {
                          return 'Password is too week';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        myPassword = val;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AppButton(
                        textButton: 'Sign In',
                        onPressed: () async {
                          var user = await signIn();
                          if (user != null) {
                            Get.offAll(const HomeScreen());
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
