import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../controller/order_controller.dart';
import '../component/show_loading.dart';
import '../widget/button.dart';

class EditOrder extends StatelessWidget {
   EditOrder({Key? key,required this.noteRef,required this.docID}) : super(key: key);

   final noteRef;
   final docID;

  GlobalKey<FormState> formState = GlobalKey<FormState>();


   @override


  FocusNode focusOne = FocusNode();

  FocusNode focusTow = FocusNode();

  FocusNode focusThree = FocusNode();

  FocusNode focusFour = FocusNode();

  FocusNode focusFive = FocusNode();

  @override
  Widget build(BuildContext context) {
    final OrderController controller = Get.put(OrderController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Add New Order'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode focusScopeNode = FocusScope.of(context);
            if (!focusScopeNode.hasPrimaryFocus) {
              focusScopeNode.unfocus();
            }
          },
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.all(10),
              child: Form(
                key: formState,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Name'),
                        suffixIcon: Icon(Icons.person),
                        hintText: 'Enter Name',
                      ),
                      controller: controller.nameController..text = noteRef['name'],
                      validator: (val) {
                        if (val!.length > 50) {
                          return 'Name is too long';
                        }
                        if (val.isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                      focusNode: focusOne,
                      onFieldSubmitted: (val) {
                        FocusScope.of(context).requestFocus(focusTow);
                      },
                      toolbarOptions: const ToolbarOptions(
                          copy: true, cut: true, paste: true, selectAll: true),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    IntlPhoneField(
                      controller: controller.phoneNumberController..text = noteRef['phone'],
                      focusNode: focusTow,
                      onSubmitted: (val) {
                        FocusScope.of(context).requestFocus(focusThree);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      initialCountryCode: 'JO',
                      onChanged: (phone) {

                      },
                      validator: (val) {
                        if (val!.number.isEmpty) {
                          return 'Please enter phone number';
                        }
                        if (val.number.length <= 9) {
                          return '';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: controller.addressController..text = noteRef['address'],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Address'),
                        suffixIcon: Icon(Icons.location_on),
                        hintText: 'Enter Address',
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Address is required';
                        }
                        return null;
                      },
                      toolbarOptions: const ToolbarOptions(
                          copy: true, cut: true, paste: true, selectAll: true),
                      focusNode: focusThree,
                      onFieldSubmitted: (val) {
                        FocusScope.of(context).requestFocus(focusFour);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: controller.itemsController..text = noteRef['items'],
                      focusNode: focusFour,
                      onFieldSubmitted: (val) {
                        FocusScope.of(context).requestFocus(focusFive);
                      },
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Items Details'),
                        suffixIcon: Icon(Icons.note_add),
                        hintText: 'Enter Items Details',
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Items is required';
                        }
                        return null;
                      },
                      toolbarOptions: const ToolbarOptions(
                          copy: true, cut: true, paste: true, selectAll: true),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: controller.priceController..text = noteRef['price'],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Price'),
                        suffixIcon: Icon(Icons.attach_money_outlined),
                        hintText: 'Enter Order Price',
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Order price is required';
                        }
                        return null;
                      },
                      focusNode: focusFive,
                      toolbarOptions: const ToolbarOptions(
                          copy: true, cut: true, paste: true, selectAll: true),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: AppButton(
                        textButton: 'Add Images',
                        onPressed: () {
                          controller.pickImages();
                        },
                      ),
                    ),
                    Obx(
                          () => Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5),
                            ),
                        width: double.infinity,
                        height: 400,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                              itemCount: controller.imageFileList.length,
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Image.file(
                                      File(controller
                                          .imageFileList[index].path),
                                      fit: BoxFit.cover,
                                    ));
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          if (formState.currentState!.validate()) {
            final connectivityResult = await (Connectivity().checkConnectivity());
            if(connectivityResult == ConnectivityResult.none){
              Get.defaultDialog(title: 'Connection',middleText: 'No Internet Connection');
            }else{

              controller.editOrder(docID);
            }

          }
        },
        child: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
