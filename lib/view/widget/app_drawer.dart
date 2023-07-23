import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/show_loading.dart';
import '../screen/login.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  signOut() async {
    showLoading(context);
    await FirebaseAuth.instance.signOut();
    Get.offAll(Login());
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(

          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Alhureyah Home'),
              accountEmail: Text('alhureyahhome50@gmail.com'),
              currentAccountPicture: ClipOval(child: Container(color: Colors.white,child: Image.asset('assets/images/hlogo.png')),),
            ),
            ListTile(title: Text('LogOut'),trailing: Icon(Icons.output_outlined),onTap: () {
              signOut();
            },)
          ],
        ),
      ),
    );
  }
}
