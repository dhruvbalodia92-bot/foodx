import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyOrdersScreen extends StatelessWidget {
const MyOrdersScreen({super.key});

String formatDate(DateTime date) {
final hour = date.hour > 12
? date.hour - 12
: date.hour == 0
? 12
: date.hour;

final minute = date.minute.toString().padLeft(2, '0');
final period = date.hour >= 12 ? "PM" : "AM";

return "${date.day}/${date.month}/${date.year} • $hour:$minute $period";
}

String getItemsSummary(List<dynamic> items) {
return items
.map((item) => "${item['name']} × ${item['quantity']}")
.join(", ");
}

@override
Widget build(BuildContext context) {
  final user = FirebaseAuth.instance.currentUser;
  print("Current UID: ${FirebaseAuth.instance.currentUser?.uid}");



return Scaffold(
backgroundColor: Colors.grey[100],

appBar: AppBar(
centerTitle: true,
title: const Text(
"My Orders",
style: TextStyle(fontWeight: FontWeight.bold),
),
),

  body: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection("orders")
        .where(
      "userId",
      isEqualTo: FirebaseAuth.instance.currentUser!.uid,
    )
        .orderBy("createdAt", descending: true)
        .snapshots(),


builder: (context, snapshot) {
  print(snapshot.error);
  print(snapshot.hasError);
  if (snapshot.hasError) {
    return Center(
      child: Text(snapshot.error.toString()),
    );
  }


if (snapshot.connectionState == ConnectionState.waiting) {
return const Center(
child: CircularProgressIndicator(
color: Colors.orange,
),
);
}

if (!snapshot.hasData ||
snapshot.data!.docs.isEmpty) {
return const _EmptyOrdersView();
}

final orders = snapshot.data!.docs;
  for (var doc in orders) {
    print(doc.data());
  }

return ListView.separated(
padding: const EdgeInsets.all(20),
itemCount: orders.length,

  separatorBuilder: (context, index) =>
  const SizedBox(height: 15),

itemBuilder: (context, index) {

  final order =
  orders[index].data() as Map<String, dynamic>;

  print("Order UserId: ${order['userId']}");

  final List<dynamic> items =
      order['items'] ?? [];

final Timestamp? timestamp =
order['createdAt'];

final DateTime date =
timestamp?.toDate() ??
DateTime.now();

return Container(
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
  Row(
    children: [
      Expanded(
        child: Text(
          order['orderId'] ?? "",
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          order['status'] ?? "Pending",
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    ],
  ),

  const SizedBox(height: 12),

  Text(
    getItemsSummary(items),
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: const TextStyle(
      color: Colors.grey,
      fontSize: 14,
      height: 1.4,
    ),
  ),

  const Padding(
    padding: EdgeInsets.symmetric(vertical: 14),
    child: Divider(),
  ),

  Row(
    children: [
      const Icon(
        Icons.payments_outlined,
        color: Colors.orange,
        size: 20,
      ),

      const SizedBox(width: 7),

      Text(
        "₹${order['totalAmount']}",
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(width: 15),

      Expanded(
        child: Text(
          order['paymentMethod'] == "COD"
              ? "Cash on Delivery"
              : "Online Payment",
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
      ),
    ],
  ),

  const SizedBox(height: 12),

  Row(
    children: [
      const Icon(
        Icons.access_time,
        size: 18,
        color: Colors.grey,
      ),

      const SizedBox(width: 7),

      Text(
        formatDate(date),
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 13,
        ),
      ),
    ],
  ),
],
),
);
},
);
},
),
);
}
}

class _EmptyOrdersView extends StatelessWidget {
  const _EmptyOrdersView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 60,
                color: Colors.orange,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "No orders yet",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Your previous orders will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}