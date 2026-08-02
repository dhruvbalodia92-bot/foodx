import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/order_model.dart';

class OrderDetailsScreen extends StatelessWidget {
final String orderId;

const OrderDetailsScreen({
super.key,
required this.orderId,
});

int getStatusIndex(String status) {
switch (status) {
case "Pending":
return 0;

case "Accepted":
return 1;

case "Preparing":
return 2;

case "Out For Delivery":
return 3;

case "Delivered":
return 4;

default:
return 0;
}
}

Color getStatusColor(String status) {
switch (status) {
case "Pending":
return Colors.orange;

case "Accepted":
return Colors.blue;

case "Preparing":
return Colors.deepOrange;

case "Out For Delivery":
return Colors.purple;

case "Delivered":
return Colors.green;

case "Cancelled":
return Colors.red;

default:
return Colors.grey;
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.grey.shade100,

appBar: AppBar(
centerTitle: true,
title: const Text(
"Order Details",
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
),

body: StreamBuilder<DocumentSnapshot>(
stream: FirebaseFirestore.instance
.collection("orders")
.doc(orderId)
.snapshots(),
builder: (context, snapshot) {
if (snapshot.connectionState ==
ConnectionState.waiting) {
return const Center(
child: CircularProgressIndicator(),
);
}

if (!snapshot.hasData ||
!snapshot.data!.exists) {
return const Center(
child: Text("Order Not Found"),
);
}

final order = OrderModel.fromMap(
snapshot.data!.data()
as Map<String, dynamic>,
);

final items = order.items;

return SingleChildScrollView(
padding: const EdgeInsets.all(18),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [

/// ORDER HEADER

Container(
width: double.infinity,
padding: const EdgeInsets.all(18),
decoration: BoxDecoration(
color: Colors.white,
borderRadius:
BorderRadius.circular(18),
),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [

Text(
order.orderId,
style: const TextStyle(
fontSize: 20,
fontWeight:
FontWeight.bold,
),
),

const SizedBox(height: 15),

Row(
children: [

Container(
padding:
const EdgeInsets.symmetric(
horizontal: 12,
vertical: 6,
),
decoration: BoxDecoration(
color: getStatusColor(
order.status)
    .withValues(alpha: 0.12),
borderRadius:
BorderRadius.circular(
20),
),
child: Text(
order.status,
style: TextStyle(
color:
getStatusColor(
order.status),
fontWeight:
FontWeight.bold,
),
),
),

const Spacer(),

Text(
"₹${order.totalAmount}",
style:
const TextStyle(
fontSize: 22,
fontWeight:
FontWeight.bold,
),
),
],
),
],
),
),

const SizedBox(height: 22),

/// ORDERED ITEMS
const Text(
"Ordered Items",
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 12),

...items.map((item) {
return Card(
elevation: 0,
margin:
const EdgeInsets.only(bottom: 10),
color: Colors.white,
shape: RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(15),
),
child: ListTile(
leading: CircleAvatar(
backgroundColor:
Colors.orange.shade50,
child: const Icon(
Icons.fastfood,
color: Colors.orange,
),
),
title: Text(
item["name"] ?? "",
style: const TextStyle(
fontWeight:
FontWeight.w600,
),
),
subtitle: Text(
"Quantity : ${item["quantity"]}",
),
trailing: Text(
"₹${item["totalPrice"]}",
style: const TextStyle(
fontWeight:
FontWeight.bold,
fontSize: 16,
),
),
),
);
}),

const SizedBox(height: 25),

/// DELIVERY ADDRESS

const Text(
"Delivery Address",
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 12),

Card(
elevation: 0,
color: Colors.white,
shape: RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(15),
),
child: Padding(
padding:
const EdgeInsets.all(16),
child: Row(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [

const Icon(
Icons.location_on,
color: Colors.orange,
),

const SizedBox(width: 12),

Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment
.start,
children: [

Text(
order.address?["house"] ??
"",
style:
const TextStyle(
fontWeight:
FontWeight
.bold,
),
),

const SizedBox(
height: 5),

Text(
order.address?["area"] ??
"",
),

if ((order.address?[
"landmark"] ??
"")
.toString()
.isNotEmpty)
Text(
order.address![
"landmark"],
),

Text(
"${order.address?["city"] ?? ""}, ${order.address?["state"] ?? ""}",
),
],
),
),
],
),
),
),

const SizedBox(height: 25),

/// PAYMENT

const Text(
"Payment",
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 12),

Card(
elevation: 0,
color: Colors.white,
shape: RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(15),
),
child: ListTile(
leading: const Icon(
Icons.payments,
color: Colors.orange,
),
title: Text(
order.paymentMethod == "COD"
? "Cash On Delivery"
: "Online Payment",
),
subtitle: Text(
"Payment Status : ${order.paymentStatus}",
),
),
),

const SizedBox(height: 25),

/// TOTAL

Card(
elevation: 0,
color: Colors.white,
shape: RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(15),
),
child: Padding(
padding:
const EdgeInsets.all(18),
child: Row(
children: [

const Text(
"Total Amount",
style: TextStyle(
fontSize: 18,
fontWeight:
FontWeight.bold,
),
),

const Spacer(),

Text(
"₹${order.totalAmount}",
style: const TextStyle(
fontSize: 22,
color: Colors.orange,
fontWeight:
FontWeight.bold,
),
),
],
),
),
),

const SizedBox(height: 25),

/// ORDER TIMELINE
  const Text(
    "Order Timeline",
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),

  const SizedBox(height: 12),

  Card(
    elevation: 0,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ...[
            "Pending",
            "Accepted",
            "Preparing",
            "Out For Delivery",
            "Delivered",
          ].asMap().entries.map((entry) {
            final index = entry.key;
            final status = entry.value;

            final completed =
                index <= getStatusIndex(order.status);

            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                completed
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: completed
                    ? Colors.green
                    : Colors.grey,
              ),
              title: Text(
                status,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: completed
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
            );
          }),
        ],
      ),
    ),
  ),

  const SizedBox(height: 30),
],
),
);
},
),
);
}
}