import 'dart:io';
import 'package:alhureyah_customer_service/controller/order_controller.dart';
import 'package:alhureyah_customer_service/view/component/show_loading.dart';
import 'package:alhureyah_customer_service/view/widget/button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class AddOrder extends StatelessWidget {
  AddOrder({Key? key}) : super(key: key);

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  FocusNode focusOne = FocusNode();
  FocusNode focusTow = FocusNode();
  FocusNode focusThree = FocusNode();
  FocusNode focusFour = FocusNode();
  FocusNode focusFive = FocusNode();

  @override
  Widget build(BuildContext context) {
    final OrderController _controller = Get.put(OrderController());
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
                      controller: _controller.nameController,
                      validator: (val) {
                        if (val!.length > 50) {
                          return 'Name is too long';
                        }
                        if (val.length < 1) {
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
                      controller: _controller.phoneNumberController,
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
                        print(phone.completeNumber);
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
                      controller: _controller.addressController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Address'),
                        suffixIcon: Icon(Icons.location_on),
                        hintText: 'Enter Address',
                      ),
                      validator: (val) {
                        if (val!.length < 1) {
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
                      controller: _controller.itemsController,
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
                        if (val!.length < 1) {
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
                      controller: _controller.priceController,
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
                    const Text(
                      'Order Take by:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey)),
                      child: Obx(
                            () => Column(
                          children: [
                            RadioListTile(
                                title: const Text('Qusai'),
                                value: 'Qusai',
                                groupValue: _controller.person.value,
                                onChanged: (val) {
                                  _controller.person.value = val!;
                                }),
                            RadioListTile(
                                title: const Text('Qattawi'),
                                value: 'Qattawi',
                                groupValue: _controller.person.value,
                                onChanged: (val) {
                                  _controller.person.value = val!;
                                }),
                            RadioListTile(
                                title: const Text('Mohammad'),
                                value: 'Mohammad',
                                groupValue: _controller.person.value,
                                onChanged: (val) {
                                  _controller.person.value = val!;
                                }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: AppButton(
                        textButton: 'Add Images',
                        onPressed: () {
                          _controller.pickImages();
                        },
                      ),
                    ),
                    Obx(
                          () => Container(
                        width: double.infinity,
                        height: 400,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                              itemCount: _controller.imageFileList.length,
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Image.file(
                                      File(_controller
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
            if(_controller.person.value.isNotEmpty){
              if (_controller.imageFileList.isNotEmpty) {
                final connectivityResult = await (Connectivity().checkConnectivity());
                if(connectivityResult == ConnectivityResult.none){
                  Get.defaultDialog(title: 'Connection',middleText: 'No Internet Connection');
                }else{

                  _controller.addOrder();
                }
              } else {
                Get.defaultDialog(title:'Required',middleText: 'You forget add image' );
              }
            }else{
              Get.defaultDialog(title: 'Required',middleText: 'You forget select how booking this order?');
            }
          }
        },
        child: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }

}
