import 'package:alhureyah_customer_service/view/component/show_loading.dart';
import 'package:alhureyah_customer_service/view/screen/home_screen.dart';
import 'package:alhureyah_customer_service/view/screen/order_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../size_config.dart';
import '../themes.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:url_launcher/url_launcher.dart';

class ListNotes extends StatelessWidget {
  ListNotes({Key? key, required this.notes, required this.docId})
      : super(key: key);

  final notes;
  final docId;
  final noteRef = FirebaseFirestore.instance.collection('Notes');
  final wMessage =
      'أسرة الحرية هوم تتمنى لكم يوم سعيد و نرجو ان خدمتنا و منتجاتنا قد نالت اعجابكم';

  void sendWhatsappMessage(String phoneNumber) async {
    String url = 'https://wa.me:/$phoneNumber?text=$wMessage';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      print('Error ==================================');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          Get.defaultDialog(
              title: 'Connection', middleText: 'No Internet Connection');
        } else {
          Get.to(OrderDetails(
            noteRef: notes,
            docId: docId,
          ));
        }
      },
      onLongPress: () {
        Get.bottomSheet(_buildBottomSheet(context));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 5,
              child: notes['image'] != ''
                  ? Container(
                      height: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(notes['image'][0]),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )
                  : const Icon(
                      Icons.done_outline,
                      size: 80,
                    ),
            ),
            Expanded(
                flex: 15,
                child: ListTile(
                    title: Text(
                      notes['name'],
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      children: [
                        Text(notes['phone'], overflow: TextOverflow.ellipsis),
                        Text(notes['address'], overflow: TextOverflow.ellipsis),
                        Text(notes['Date'], overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    trailing: Text(
                      '${notes['price']}\nJOD',
                      style: Themes()
                          .bodyStyle
                          .copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ))),
            Expanded(
              flex: 1,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorNote(),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
      ),
    );
  }

  Color colorNote() {
    if (notes['status'] == 'Not Ready') {
      return Colors.blue;
    } else if (notes['status'] == 'On Way') {
      return Colors.orange;
    } else if (notes['status'] == 'Canceled') {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  String statusText() {
    if (notes['status'] == 'Not Ready') {
      return 'On Way';
    } else if (notes['status'] == 'On Way') {
      return 'Arrived';
    } else {
      return 'Done';
    }
  }

  _buildButton(
      {required String label,
      required Function() onTap,
      required Color clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 50,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: isClose
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? Themes().titleHeadingStyle
                : Themes().titleHeadingStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView _buildBottomSheet(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: notes['status'] != 'On Way'
            ? notes['status'] != 'Canceled'
                ? SizeConfig.screenHeight * 0.33
                : SizeConfig.screenHeight * 0.20
            : SizeConfig.screenHeight * 0.40,
        child: Column(
          children: [
            Flexible(
                child: Container(
              margin: const EdgeInsets.only(top: 5),
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            )),
            const SizedBox(
              height: 20,
            ),
            notes['status'] != 'Canceled'
                ? Expanded(
                    flex: 1,
                    child: _buildButton(
                        label: statusText(),
                        onTap: () async {
                          final connectivityResult = await (Connectivity().checkConnectivity());
                          if(connectivityResult == ConnectivityResult.none){
                            Get.defaultDialog(title: 'Connection',middleText: 'No Internet Connection');
                          }else{
                            if (notes['status'] == 'Not Ready') {
                              return showDialog(
                                  context: Get.context!,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Order Status'),
                                    content: const Text(
                                        'Are you sure that the order has on way'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Get.back();
                                          try {
                                            await noteRef.doc(docId).update({
                                              'status': 'On Way',
                                            });
                                          } catch (e) {
                                            return Get.defaultDialog(
                                                title: 'Error',
                                                middleText: '$e');
                                          }

                                          Get.back();
                                        },
                                        child: const Text('Sure'),
                                      ),
                                    ],
                                  ));
                            } else if (notes['status'] == 'On Way') {
                              return showDialog(
                                  context: Get.context!,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Order Status'),
                                    content: const Text(
                                        'Are you sure that the order has arrived'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Get.back();
                                          showLoading(context);
                                          List imageCount = notes['image'];
                                          for (int i = 0;
                                          i < imageCount.length;
                                          i++) {
                                            try {
                                              await FirebaseStorage.instance
                                                  .refFromURL(
                                                  notes['image'][i])
                                                  .delete();
                                            } catch (e) {
                                              return Get.defaultDialog(
                                                  title: 'Error',
                                                  middleText: '$e');
                                            }
                                          }
                                          try {
                                            await noteRef.doc(docId).update({
                                              'status': 'Arrived',
                                              'image': ''
                                            });
                                          } catch (e) {
                                            return Get.defaultDialog(
                                                title: 'Error',
                                                middleText: '$e');
                                          }
                                          Get.back();
                                          sendWhatsappMessage(notes['phone']);
                                        },
                                        child: const Text('Arrived'),
                                      ),
                                    ],
                                  ));
                            }
                          }

                        },
                        clr: primaryClr))
                : Container(),
            notes['status'] != 'Canceled'
                ? Expanded(
                    child: _buildButton(
                        label: 'Order Schedule'.tr,
                        onTap: () async {
                          _getDateFromUser(context);
                        },
                        clr: primaryClr))
                : Container(),
            notes['status'] == 'On Way'
                ? Expanded(
                    child: _buildButton(
                    label: 'Order Canceled',
                    onTap: () async {
                      return showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Order Status'),
                                content: const Text(
                                    'Are you sure that the order has canceled'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Get.back();
                                      final connectivityResult = await (Connectivity().checkConnectivity());
                                      if(connectivityResult == ConnectivityResult.none){
                                        Get.defaultDialog(title: 'Connection',middleText: 'No Internet Connection');
                                      }else{
                                        try {
                                          await noteRef.doc(docId).update({
                                            'status': 'Canceled',
                                          });
                                        } catch (e) {
                                          return Get.defaultDialog(
                                              title: 'Error', middleText: '$e');
                                        }
                                        Get.back();
                                      }

                                    },
                                    child: const Text('Sure'),
                                  ),
                                ],
                              ));
                    },
                    clr: primaryClr,
                  ))
                : Container(),
            Expanded(
                child: _buildButton(
                    label: 'Delete Order'.tr,
                    onTap: () async {
                      final connectivityResult = await (Connectivity().checkConnectivity());
                      if(connectivityResult == ConnectivityResult.none){
                        Get.defaultDialog(title: 'Connection',middleText: 'No Internet Connection');
                      }else{
                        Get.back();
                        try {
                          await noteRef.doc(docId).delete();
                        } catch (e) {
                          return Get.defaultDialog(
                              title: 'Error', middleText: '$e');
                        }
                        if (notes['image'] != '') {
                          List imageCount = notes['image'];
                          for (int i = 0; i < imageCount.length; i++) {
                            try {
                              await FirebaseStorage.instance
                                  .refFromURL(notes['image'][i])
                                  .delete();
                            } catch (e) {
                              return Get.defaultDialog(
                                  title: 'Error', middleText: '$e');
                            }
                          }
                        }
                      }

                    },
                    clr: primaryClr)),
          ],
        ),
      ),
    );
  }

  _getDateFromUser(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      String newDate = DateFormat('yyyy-MM-dd – kk:mm')
          .format(pickedDate.add(Duration(hours: 10)))
          .toString();
      String newD = DateFormat('yyyy-MM-dd').format(pickedDate).toString();

      final connectivityResult = await (Connectivity().checkConnectivity());
      if(connectivityResult == ConnectivityResult.none){
        Get.defaultDialog(title: 'Connection',middleText: 'No Internet Connection');
      }else{
        try {
          await noteRef.doc(docId).update({'Date': newDate, 'dateDay': newD});
        } catch (e) {
          return Get.defaultDialog(title: 'Error', middleText: '$e');
        }
        Get.back();
      }

    }
  }
}
