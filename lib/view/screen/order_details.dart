import 'package:alhureyah_customer_service/view/screen/edit_order.dart';
import 'package:alhureyah_customer_service/view/themes.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetails extends StatelessWidget {
   OrderDetails({
    Key? key,
    required this.noteRef,
    required this.docId,
  }) : super(key: key);

  final noteRef;
  final docId;
  late final imageCount ;
  @override
  Widget build(BuildContext context) {
    if(noteRef['image'] != '') imageCount = noteRef['image'];
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              Text(
                'Order details',
                textAlign: TextAlign.center,
                style: Themes().headingStyle,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('Name: '),
                          Text(
                            noteRef['name'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Phone Number: '),
                          Text(
                            noteRef['phone'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Address: '),
                          Text(
                            noteRef['address'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Items: '),
                          Text(
                            noteRef['items'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Order by: '),
                          Text(
                            noteRef['order by'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
               Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: noteRef['image'] != '' ? GridView.builder(
                      itemCount: imageCount.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            padding: const EdgeInsets.all(5.0),
                            child: InkWell(
                                onTap: () {
                                  launchUrl(Uri.parse(noteRef['image'][index]),mode: LaunchMode.externalApplication);
                                },
                                child: Image.network(noteRef['image'][index])));
                      }) : Container(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () =>
            Get.to(() => EditOrder(noteRef: noteRef, docID: docId)),
      ),
    );
  }
}
