import 'dart:ffi';

import 'package:alhureyah_customer_service/view/screen/add_order.dart';
import 'package:alhureyah_customer_service/view/widget/all_orders.dart';

import 'package:alhureyah_customer_service/view/widget/app_drawer.dart';
import 'package:alhureyah_customer_service/view/widget/returned_orders.dart';
import 'package:alhureyah_customer_service/view/widget/today_orders.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../size_config.dart';
import '../themes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  final listName = [TodayOders(), AllOrders(), ReturnedOrders()];

  @override
  void initState() {

    connectivityCheck();

    super.initState();
  }
  void connectivityCheck()async{
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.none){
      Get.defaultDialog(title: 'No Internet',middleText: 'please Check Internet Connection');
    }

  }
  Future<void> _refResh(){
    setState(() {

    });
    return Future.delayed(Duration(milliseconds: 500));
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(
          'Alhureyah Home',
          style: Themes().titleHeadingStyle,
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refResh,
        child: SafeArea(
          child: listName[_index],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddOrder());
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                  child: GNav(
                    rippleColor: Colors.grey.withOpacity(0.8),
                    // tab button ripple color when pressed
                    hoverColor: Colors.grey.withOpacity(0.7),
                    // tab button hover color
                    haptic: true,
                    // haptic feedback
                    tabBorderRadius: 20,
                    tabActiveBorder: Border.all(color: Colors.black, width: 1),
                    // tab button border
                    tabBorder: Border.all(color: Colors.grey, width: 1),
                    // tab button border
                    tabShadow: const [
                      BoxShadow(color: Colors.white, blurRadius: 8)
                    ],
                    // tab button shadow
                    curve: Curves.easeOutExpo,
                    // tab animation curves
                    duration: const Duration(milliseconds: 700),
                    // tab animation duration
                    gap: 8,
                    // the tab button gap between icon and text
                    color: Colors.grey[800],
                    // unselected icon color
                    activeColor: Colors.purple,
                    // selected icon and text color
                    iconSize: 24,
                    // tab button icon size
                    tabBackgroundColor: Colors.purple.withOpacity(0.1),
                    // selected tab background color
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    // navigation bar padding
                    tabs: const [
                      GButton(
                        icon: Icons.today,
                        text: 'Today',
                      ),
                      GButton(
                        icon: Icons.clear_all_outlined,
                        text: 'All Orders',
                      ),
                      GButton(
                        icon: Icons.keyboard_return,
                        text: 'Returned',
                      )
                    ],
                    selectedIndex: _index,
                    onTabChange: (val) {
                      setState(() {
                        _index = val;
                      });
                    },
                  )))),
    );
  }
}
