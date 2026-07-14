import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../address/add_address_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';


class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPaymentMethod = "COD";
  Map<String, String>? selectedAddress;
  String get verifiedPhoneNumber {
    return FirebaseAuth.instance.currentUser?.phoneNumber ?? "";
  }
  @override
  void initState() {
    super.initState();
    loadSavedAddress();
  }

  Future<void> loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();

    final house = prefs.getString('address_house');

    if (house == null || house.isEmpty) {
      return;
    }

    final savedAddress = <String, String>{
      "house": house,
      "area": prefs.getString('address_area') ?? "",
      "landmark": prefs.getString('address_landmark') ?? "",
      "city": prefs.getString('address_city') ?? "",
      "state": prefs.getString('address_state') ?? "Rajasthan",
      "type": prefs.getString('address_type') ?? "Home",
    };

    if (!mounted) return;

    setState(() {
      selectedAddress = savedAddress;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    const int deliveryFee = 30;
    const int deliveryDiscount = 30;

    final int grandTotal =
        cart.totalPrice + deliveryFee - deliveryDiscount;

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text(
          "Checkout",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address Heading
            const Text(
              "Delivery Address",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Address Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.orange,
                    size: 28,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedAddress?["type"] ?? "Home",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          selectedAddress == null
                              ? "Phulera, Rajasthan"
                              : [
                            selectedAddress!["house"],
                            selectedAddress!["area"],
                            if (selectedAddress!["landmark"] != null &&
                                selectedAddress!["landmark"]!.isNotEmpty)
                              selectedAddress!["landmark"],
                            selectedAddress!["city"],
                            selectedAddress!["state"],
                          ].whereType<String>().join(", "),
                          style: const TextStyle(
                            color: Colors.grey,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  TextButton(
                    onPressed: () async {
                      final result = await Navigator.push<Map<String, String>>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddAddressScreen(),
                        ),
                      );

                      if (result != null && mounted) {
                        setState(() {
                          selectedAddress = result;
                        });
                      }
                    },
                    child: Text(
                      selectedAddress == null ? "ADD" : "CHANGE",
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Contact Number Heading
            const Text(
              "Contact Number",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.phone_outlined,
                      color: Colors.orange,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          verifiedPhoneNumber.isEmpty
                              ? "Phone number unavailable"
                              : verifiedPhoneNumber,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Row(
                          children: [
                            const Icon(
                              Icons.verified,
                              color: Colors.green,
                              size: 17,
                            ),

                            const SizedBox(width: 5),

                            Text(
                              verifiedPhoneNumber.isEmpty
                                  ? "Not available"
                                  : "Verified number",
                              style: TextStyle(
                                color: verifiedPhoneNumber.isEmpty
                                    ? Colors.grey
                                    : Colors.green,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Payment Method Heading
            const Text(
              "Payment Method",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // COD Option
            _PaymentOption(
              icon: Icons.payments_outlined,
              title: "Cash on Delivery",
              subtitle: "Pay when your order arrives",
              value: "COD",
              selectedValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value;
                });
              },
            ),

            const SizedBox(height: 12),

            // Online Payment Option
            _PaymentOption(
              icon: Icons.account_balance_wallet_outlined,
              title: "Pay Online",
              subtitle: "UPI, cards and other payment methods",
              value: "ONLINE",
              selectedValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value;
                });
              },
            ),

            const SizedBox(height: 25),

            // Order Summary Heading
            const Text(
              "Order Summary",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),

              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Item Total"),
                      Text("₹${cart.totalPrice}"),
                    ],
                  ),

                  const SizedBox(height: 12),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Delivery Fee"),

                      Row(
                        children: [
                          Text(
                            "₹30",
                            style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),

                          SizedBox(width: 8),

                          Text(
                            "FREE",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "To Pay",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "₹$grandTotal",
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Place Order Button
            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: cart.items.isEmpty
                    ? null
                    : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        selectedPaymentMethod == "COD"
                            ? "COD selected — Order placement coming next"
                            : "Online payment selected — Payment integration coming next",
                      ),
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                child: Text(
                  "Place Order • ₹$grandTotal",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == selectedValue;

    return InkWell(
      borderRadius: BorderRadius.circular(15),

      onTap: () {
        onChanged(value);
      },

      child: Container(
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected
                ? Colors.orange
                : Colors.transparent,
            width: 2,
          ),
        ),

        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.orange : Colors.grey,
              size: 28,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? Colors.orange : Colors.grey,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}