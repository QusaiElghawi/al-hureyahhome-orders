import 'dart:io';
import 'dart:math';
import 'package:alhureyah_customer_service/model/order_model.dart';

import 'package:alhureyah_customer_service/view/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import '../view/component/show_loading.dart';

class OrderController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController itemsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  RxList<dynamic> imageFileList = <dynamic>[].obs;
  RxString person = ''.obs;
  RxString statusC = 'Not Ready'.obs;

  Future<void> addOrder() async {
    try {
      showLoading(Get.context!);
      final List<String> imageUrls = await _uploadImages();

      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {

          final order = Orders(
            name: nameController.text,
            phone: phoneNumberController.text,
            address: addressController.text,
            items: itemsController.text,
            price: priceController.text,
            image: imageUrls,
            Date: DateFormat('yyyy-MM-dd – kk:mm')
                .format(DateTime.now())
                .toString(),
            dateDay: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            uid: user.uid,
            orderby: person.toString(),
            status: statusC.value,
          );

          await FirebaseFirestore.instance
              .collection('Notes')
              .add(order.toJson());

          clearForm();
          Get.offAll(HomeScreen());
          Get.snackbar('Success', 'Order added successfully!');

      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  Future<void> editOrder(String orderId) async {
    if (imageFileList.isNotEmpty) {
      try {
        showLoading(Get.context!);
        final List<String> imageUrls = await _uploadImages();

        final User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('Notes')
              .doc(orderId)
              .update({
            'name': nameController.text,
            'phone': phoneNumberController.text,
            'address': addressController.text,
            'items': itemsController.text,
            'price': priceController.text,
            'Date': DateFormat('yyyy-MM-dd – kk:mm')
                .format(DateTime.now())
                .toString(),
            'dateDay':
                DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
            'image': imageUrls,
          });

          clearForm();

          Get.snackbar('Success', 'Order added successfully!');
        }
        Get.offAll(HomeScreen());
      } catch (e) {
        Get.snackbar('Error', 'An error occurred: $e');
      }
    } else {
      try {
        showLoading(Get.context!);
        final User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('Notes')
              .doc(orderId)
              .update({
            'name': nameController.text,
            'phone': phoneNumberController.text,
            'address': addressController.text,
            'items': itemsController.text,
            'price': priceController.text,
            'Date': DateFormat('yyyy-MM-dd – kk:mm')
                .format(DateTime.now())
                .toString(),
            'dateDay':
                DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
          });
          clearForm();

          Get.snackbar('Success', 'Order added successfully!');
        }
        Get.offAll(HomeScreen());
      } catch (e) {
        Get.snackbar('Error', 'An error occurred: $e');
      }
    }
  }

  Future<List<String>> _uploadImages() async {
    List<String> imageUrl = [];
    var rand = Random().nextInt(1000000);
    for (var index = 0; index < imageFileList.length; index++) {
      String imageName = '$rand${basename(imageFileList[index].path)}';
      Reference ref = FirebaseStorage.instance.ref('images').child(imageName);
      await ref.putFile(File(imageFileList[index].path));
      imageUrl.add(await ref.getDownloadURL());
    }
    return imageUrl;
  }

  Future<void> pickImages() async {
    final ImagePicker imagePicker = ImagePicker();
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList.value =
          selectedImages.map((image) => File(image.path)).toList();
    }
  }

  void selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      dateController.text =
          picked.toString(); // You can format the date as needed
    }
  }

  void clearForm() {
    nameController.clear();
    phoneNumberController.clear();
    addressController.clear();
    itemsController.clear();
    priceController.clear();
    noteController.clear();
    imageFileList.value = [];
    person.value = '';
    statusC.value = 'Not Ready';
  }
}
