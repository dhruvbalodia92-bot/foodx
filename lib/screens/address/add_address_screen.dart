import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final houseController = TextEditingController();
  final areaController = TextEditingController();
  final landmarkController = TextEditingController();
  final cityController = TextEditingController(
    text: "Phulera",
  );

  String selectedAddressType = "Home";

  @override
  void dispose() {
    houseController.dispose();
    areaController.dispose();
    landmarkController.dispose();
    cityController.dispose();
    super.dispose();
  }

  Future<void> saveAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'address_house',
      houseController.text.trim(),
    );

    await prefs.setString(
      'address_area',
      areaController.text.trim(),
    );

    await prefs.setString(
      'address_landmark',
      landmarkController.text.trim(),
    );

    await prefs.setString(
      'address_city',
      cityController.text.trim(),
    );

    await prefs.setString(
      'address_state',
      'Rajasthan',
    );

    await prefs.setString(
      'address_type',
      selectedAddressType,
    );

    final address = <String, String>{
      "house": houseController.text.trim(),
      "area": areaController.text.trim(),
      "landmark": landmarkController.text.trim(),
      "city": cityController.text.trim(),
      "state": "Rajasthan",
      "type": selectedAddressType,
    };

    if (!mounted) return;

    Navigator.pop(context, address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text(
          "Add Delivery Address",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Address Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: houseController,
                decoration: _inputDecoration(
                  label: "House / Flat No.",
                  icon: Icons.home_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter house or flat number";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: areaController,
                decoration: _inputDecoration(
                  label: "Street / Area / Colony",
                  icon: Icons.location_city_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter street or area";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: landmarkController,
                decoration: _inputDecoration(
                  label: "Landmark (Optional)",
                  icon: Icons.place_outlined,
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: cityController,
                decoration: _inputDecoration(
                  label: "City",
                  icon: Icons.location_on_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter city";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 25),

              const Text(
                "Save address as",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _AddressTypeButton(
                    label: "Home",
                    icon: Icons.home_outlined,
                    isSelected: selectedAddressType == "Home",
                    onTap: () {
                      setState(() {
                        selectedAddressType = "Home";
                      });
                    },
                  ),

                  _AddressTypeButton(
                    label: "Work",
                    icon: Icons.work_outline,
                    isSelected: selectedAddressType == "Work",
                    onTap: () {
                      setState(() {
                        selectedAddressType = "Work";
                      });
                    },
                  ),

                  _AddressTypeButton(
                    label: "Other",
                    icon: Icons.location_on_outlined,
                    isSelected: selectedAddressType == "Other",
                    onTap: () {
                      setState(() {
                        selectedAddressType = "Other";
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "Save Address",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
        color: Colors.orange,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.orange,
          width: 2,
        ),
      ),
    );
  }
}

class _AddressTypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _AddressTypeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.orange.shade50
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.orange
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? Colors.orange
                  : Colors.grey,
            ),

            const SizedBox(width: 7),

            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.orange
                    : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}