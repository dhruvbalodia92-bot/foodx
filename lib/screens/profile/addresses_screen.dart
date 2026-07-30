import 'package:flutter/material.dart';
import 'add_address_screen.dart';
import '../../models/address_model.dart';
import '../../services/firestore_service.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
final FirestoreService _firestoreService = FirestoreService();

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Saved Addresses"),
centerTitle: true,
),
body: StreamBuilder<List<AddressModel>>(
stream: _firestoreService.getAddresses(),
builder: (context, snapshot) {
if (snapshot.connectionState ==
ConnectionState.waiting) {
return const Center(
child: CircularProgressIndicator(),
);
}

if (snapshot.hasError) {
return Center(
child: Text(snapshot.error.toString()),
);
}

final addresses = snapshot.data ?? [];

if (addresses.isEmpty) {
return const Center(
child: Text(
"No Address Found",
style: TextStyle(fontSize: 18),
),
);
}

return ListView.builder(
padding: const EdgeInsets.all(16),
itemCount: addresses.length,
itemBuilder: (context, index) {
final address = addresses[index];

return Card(
margin: const EdgeInsets.only(bottom: 15),
elevation: 3,
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Row(
children: [
Chip(
label: Text(address.addressType),
),
const Spacer(),
if (address.isDefault)
const Chip(
backgroundColor: Colors.green,
label: Text(
"Default",
style: TextStyle(
color: Colors.white,
),
),
),
],
),

const SizedBox(height: 10),

Text(
address.fullName,
style: const TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 5),

Text(address.phone),

const SizedBox(height: 10),

Text(
"${address.houseNo}, ${address.area}",
),

if (address.landmark.isNotEmpty)
Text(
"Landmark: ${address.landmark}",
),

Text(
"${address.city}, ${address.state}",
),

Text(
"PIN: ${address.pincode}",
),

const SizedBox(height: 15),

Row(
children: [
OutlinedButton.icon(
onPressed: () async {
await _firestoreService
.setDefaultAddress(
address.id,
);
},
icon: const Icon(Icons.check),
label: const Text("Default"),
),

const SizedBox(width: 10),

OutlinedButton.icon(
onPressed: () async {
await _firestoreService
.deleteAddress(
address.id,
);
},
icon: const Icon(Icons.delete),
label: const Text("Delete"),
),
],
),
],
),
),
);
},
);
},
),

  floatingActionButton: FloatingActionButton.extended(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const AddAddressScreen(),
        ),
      );
    },
    icon: const Icon(Icons.add),
    label: const Text("Add Address"),
  ),
);
}
}
