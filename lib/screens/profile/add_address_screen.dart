import 'package:flutter/material.dart';
import '../../services/pincode_service.dart';
import '../../models/address_model.dart';
import '../../services/firestore_service.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() =>
      _AddAddressScreenState();
}

class _AddAddressScreenState
    extends State<AddAddressScreen> {
final FirestoreService _firestoreService =
FirestoreService();

final _formKey = GlobalKey<FormState>();

final TextEditingController fullNameController =
TextEditingController();

final TextEditingController phoneController =
TextEditingController();

final TextEditingController houseController =
TextEditingController();

final TextEditingController areaController =
TextEditingController();

final TextEditingController landmarkController =
TextEditingController();

final TextEditingController cityController =
TextEditingController();

final TextEditingController stateController =
TextEditingController();

final TextEditingController pinController =
TextEditingController();

String addressType = "Home";

bool isDefault = true;

bool loading = false;
bool searchingPincode = false;

String? pincodeError;

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Add Address"),
),
body: Form(
key: _formKey,
child: ListView(
padding: const EdgeInsets.all(16),
children: [
TextFormField(
controller: fullNameController,
decoration: const InputDecoration(
labelText: "Full Name",
border: OutlineInputBorder(),
),
validator: (value) =>
value!.isEmpty ? "Enter Full Name" : null,
),

const SizedBox(height: 15),

TextFormField(
controller: phoneController,
keyboardType: TextInputType.phone,
decoration: const InputDecoration(
labelText: "Mobile Number",
border: OutlineInputBorder(),
),
validator: (value) =>
value!.length != 10 ? "Enter Valid Mobile Number" : null,
),

const SizedBox(height: 15),

TextFormField(
controller: houseController,
decoration: const InputDecoration(
labelText: "House / Flat No.",
border: OutlineInputBorder(),
),
validator: (value) =>
value!.isEmpty ? "Enter House Number" : null,
),

const SizedBox(height: 15),

  TextFormField(
    controller: areaController,
    readOnly: true,
    decoration: const InputDecoration(
      labelText: "Area / Locality",
      border: OutlineInputBorder(),
      suffixIcon: Icon(Icons.location_on),
    ),
  ),

const SizedBox(height: 15),

TextFormField(
controller: landmarkController,
decoration: const InputDecoration(
labelText: "Landmark (Optional)",
border: OutlineInputBorder(),
),
),

const SizedBox(height: 15),

  TextFormField(
    controller: cityController,
    readOnly: true,
    decoration: const InputDecoration(
      labelText: "City",
      border: OutlineInputBorder(),
      suffixIcon: Icon(Icons.location_city),
    ),
  ),

const SizedBox(height: 15),

  TextFormField(
    controller: stateController,
    readOnly: true,
    decoration: const InputDecoration(
      labelText: "State",
      border: OutlineInputBorder(),
      suffixIcon: Icon(Icons.map),
    ),
  ),

const SizedBox(height: 15),

  TextFormField(
    controller: pinController,
    keyboardType: TextInputType.number,
    maxLength: 6,
    decoration: InputDecoration(
      labelText: "Pincode",
      border: const OutlineInputBorder(),
      counterText: "",
      suffixIcon: searchingPincode
          ? const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      )
          : pincodeError == null &&
          pinController.text.length == 6
          ? const Icon(
        Icons.check_circle,
        color: Colors.green,
      )
          : null,
    ),
    onChanged: _searchPincode,
    validator: (value) {
      if (value == null || value.length != 6) {
        return "Enter Valid Pincode";
      }

      if (pincodeError != null) {
        return pincodeError;
      }

      return null;
    },
  ),

const SizedBox(height: 20),

DropdownButtonFormField<String>(
value: addressType,
decoration: const InputDecoration(
labelText: "Address Type",
border: OutlineInputBorder(),
),
items: const [
DropdownMenuItem(
value: "Home",
child: Text("Home"),
),
DropdownMenuItem(
value: "Work",
child: Text("Work"),
),
DropdownMenuItem(
value: "Other",
child: Text("Other"),
),
],
onChanged: (value) {
setState(() {
addressType = value!;
});
},
),

const SizedBox(height: 15),

SwitchListTile(
value: isDefault,
title: const Text("Set as Default Address"),
onChanged: (value) {
setState(() {
isDefault = value;
});
},
),

const SizedBox(height: 20),
  SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton(
      onPressed: loading
          ? null
          : () async {
        if (!_formKey.currentState!.validate()) {
          return;
        }

        setState(() {
          loading = true;
        });

        final address = AddressModel(
          id: '',
          fullName: fullNameController.text.trim(),
          phone: phoneController.text.trim(),
          houseNo: houseController.text.trim(),
          area: areaController.text.trim(),
          landmark: landmarkController.text.trim(),
          city: cityController.text.trim(),
          state: stateController.text.trim(),
          pincode: pinController.text.trim(),
          addressType: addressType,
          isDefault: isDefault,
        );

        await _firestoreService.addAddress(address);

        if (mounted) {
          Navigator.pop(context);
        }
      },
      child: loading
          ? const CircularProgressIndicator(
        color: Colors.white,
      )
          : const Text(
        "Save Address",
        style: TextStyle(fontSize: 16),
      ),
    ),
  ),
],
),
),
);
}
Future<void> _searchPincode(String value) async {
  if (value.length != 6) {
    setState(() {
      cityController.clear();
      stateController.clear();
      pincodeError = null;
    });
    return;
  }

  setState(() {
    searchingPincode = true;
    pincodeError = null;
  });

  final result =
  await PincodeService.getAddressFromPincode(value);

  if (!mounted) return;

  if (result == null) {
    setState(() {
      searchingPincode = false;
      cityController.clear();
      stateController.clear();
      pincodeError = "Invalid Pincode";
    });

    return;
  }

  areaController.text = result["area"]!;
  cityController.text = result["city"]!;
  stateController.text = result["state"]!;

  setState(() {
    searchingPincode = false;
    pincodeError = null;
  });
}
@override
void dispose() {
  fullNameController.dispose();
  phoneController.dispose();
  houseController.dispose();
  areaController.dispose();
  landmarkController.dispose();
  cityController.dispose();
  stateController.dispose();
  pinController.dispose();
  super.dispose();
}
}