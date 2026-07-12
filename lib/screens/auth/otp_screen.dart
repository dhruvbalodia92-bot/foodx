import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home/home_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
final otp1Controller = TextEditingController();
final otp2Controller = TextEditingController();
final otp3Controller = TextEditingController();
final otp4Controller = TextEditingController();
final otp5Controller = TextEditingController();
final otp6Controller = TextEditingController();

final focus1 = FocusNode();
final focus2 = FocusNode();
final focus3 = FocusNode();
final focus4 = FocusNode();
final focus5 = FocusNode();
final focus6 = FocusNode();
int secondsRemaining = 30;
Timer? timer;
@override
void initState() {
  super.initState();
  startTimer();
}

void startTimer() {
  timer?.cancel();

  setState(() {
    secondsRemaining = 30;
  });

  timer = Timer.periodic(
    const Duration(seconds: 1),
        (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    },
  );
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("OTP Verification"),
centerTitle: true,
leading: IconButton(
icon: const Icon(Icons.arrow_back),
onPressed: () {
Navigator.pop(context);
},
),
),
body: Padding(
padding: const EdgeInsets.all(20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const SizedBox(height: 20),

const Text(
"Verify your phone",
style: TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 10),

Text(
"Enter the 6-digit OTP sent to\n+91 ${widget.phoneNumber}",
style: const TextStyle(
fontSize: 16,
color: Colors.grey,
),
),

const SizedBox(height: 40),
Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: [

// OTP 1
SizedBox(
width: 45,
child: TextField(
controller: otp1Controller,
focusNode: focus1,
keyboardType: TextInputType.number,
textAlign: TextAlign.center,
maxLength: 1,
onChanged: (value) {
if (value.length == 1) {
FocusScope.of(context).requestFocus(focus2);
}
},
decoration: const InputDecoration(
counterText: "",
border: OutlineInputBorder(),
),
),
),

// OTP 2
// OTP 2
  SizedBox(
    width: 45,
    child: KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace &&
            otp2Controller.text.isEmpty) {
          focus1.requestFocus();
        }
      },
      child: TextField(
        controller: otp2Controller,
        focusNode: focus2,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        onChanged: (value) {
          if (value.length == 1) {
            focus3.requestFocus();
          }
        },
        decoration: const InputDecoration(
          counterText: "",
          border: OutlineInputBorder(),
        ),
      ),
    ),
  ),

// OTP 3
// OTP 3
  SizedBox(
    width: 45,
    child: KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace &&
            otp3Controller.text.isEmpty) {
          focus2.requestFocus();
        }
      },
      child: TextField(
        controller: otp3Controller,
        focusNode: focus3,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        onChanged: (value) {
          if (value.length == 1) {
            focus4.requestFocus();
          }
        },
        decoration: const InputDecoration(
          counterText: "",
          border: OutlineInputBorder(),
        ),
      ),
    ),
  ),

// OTP 4
// OTP 4
  SizedBox(
    width: 45,
    child: KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace &&
            otp4Controller.text.isEmpty) {
          focus3.requestFocus();
        }
      },
      child: TextField(
        controller: otp4Controller,
        focusNode: focus4,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        onChanged: (value) {
          if (value.length == 1) {
            focus5.requestFocus();
          }
        },
        decoration: const InputDecoration(
          counterText: "",
          border: OutlineInputBorder(),
        ),
      ),
    ),
  ),

// OTP 5
// OTP 5
  SizedBox(
    width: 45,
    child: KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace &&
            otp5Controller.text.isEmpty) {
          focus4.requestFocus();
        }
      },
      child: TextField(
        controller: otp5Controller,
        focusNode: focus5,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        onChanged: (value) {
          if (value.length == 1) {
            focus6.requestFocus();
          }
        },
        decoration: const InputDecoration(
          counterText: "",
          border: OutlineInputBorder(),
        ),
      ),
    ),
  ),
// OTP 6
// OTP 6
  SizedBox(
    width: 45,
    child: KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace &&
            otp6Controller.text.isEmpty) {
          focus5.requestFocus();
        }
      },
      child: TextField(
        controller: otp6Controller,
        focusNode: focus6,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: const InputDecoration(
          counterText: "",
          border: OutlineInputBorder(),
        ),
      ),
    ),
  ),
],
),

const SizedBox(height: 40),
  SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton(
      onPressed: () async {
        String otp = otp1Controller.text +
            otp2Controller.text +
            otp3Controller.text +
            otp4Controller.text +
            otp5Controller.text +
            otp6Controller.text;

        if (otp.length != 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please enter complete OTP"),
            ),
          );
          return;
        }

        final messenger = ScaffoldMessenger.of(context);
        final navigator = Navigator.of(context);

        try {
          final PhoneAuthCredential credential =
          PhoneAuthProvider.credential(
            verificationId: widget.verificationId,
            smsCode: otp,
          );

          await FirebaseAuth.instance.signInWithCredential(credential);

          if (!mounted) return;

          messenger.showSnackBar(
            const SnackBar(
              content: Text("Phone number verified successfully!"),
            ),
          );

          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            ),
                (route) => false,
          );
        } on FirebaseAuthException catch (e) {
          if (!mounted) return;

          messenger.showSnackBar(
            SnackBar(
              content: Text(
                e.message ?? "Invalid OTP. Please try again.",
              ),
            ),
          );
        }
      },
      child: const Text(
        "Verify OTP",
        style: TextStyle(fontSize: 18),
      ),
    ),
  ),

  const SizedBox(height: 20),

  Center(
    child: secondsRemaining > 0
        ? Text(
      "Resend OTP in 00:${secondsRemaining.toString().padLeft(2, '0')}",
      style: const TextStyle(
        color: Colors.grey,
      ),
    )
        : TextButton(
      onPressed: () {
        startTimer();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("OTP resent successfully"),
          ),
        );
      },
      child: const Text(
        "Resend OTP",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
],
),
),
);
}

@override
void dispose() {
  otp1Controller.dispose();
  otp2Controller.dispose();
  otp3Controller.dispose();
  otp4Controller.dispose();
  otp5Controller.dispose();
  otp6Controller.dispose();

  focus1.dispose();
  focus2.dispose();
  focus3.dispose();
  focus4.dispose();
  focus5.dispose();
  focus6.dispose();
  timer?.cancel();

  super.dispose();
}
}