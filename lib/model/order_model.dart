class Orders {
  late String name;
  late String phone;
  late String address;
  late String items;
  late String price;

  late List<String> image;
  late String Date;
  late String dateDay;
  late String uid;
  late String orderby;
  late String status;

  Orders(
      {required this.name,
      required this.phone,
      required this.address,
      required this.items,
      required this.price,
      required this.image,
      required this.Date,
      required this.dateDay,
      required this.uid,
      required this.orderby,
      required this.status
      });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'items': items,
      'price': price,
      'image': image,
      'Date': Date,
      'dateDay': dateDay,
      'uid': uid,
      'order by': orderby,
      'status':status
    };
  }
}
