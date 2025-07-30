import 'package:flutter/material.dart';
import 'package:screen_page/Screeen/User_empl_screen/Home_bare.dart';
import 'package:screen_page/service/Auth.dart';

class Otpscreen extends StatefulWidget {
  final String email; // Add email parameter

  const Otpscreen({super.key, required this.email});

  @override
  State<Otpscreen> createState() => _SecondPageState();
}

class _SecondPageState extends State<Otpscreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  ); // ✅ Changement ici

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  int? getOtpAsInt() {
    String otpString = _controllers.map((controller) => controller.text).join();
    if (otpString.length == 6 && otpString.isNotEmpty) {
      return int.tryParse(otpString);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBEA),
      body: Stack(
        children: [
          // Cercles décoratifs
          Positioned(
            top: -70,
            right: -50,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: const Color(0xFFEAB308),
            ),
          ),
          Positioned(
            top: -70,
            left: -50,
            child: CircleAvatar(
              radius: 200,
              backgroundColor: const Color.fromARGB(
                255,
                235,
                207,
                85,
              ).withOpacity(0.3),
            ),
          ),
          Positioned(
            top: -30,
            right: -30,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: const Color.fromARGB(
                255,
                235,
                223,
                146,
              ).withOpacity(0.5),
            ),
          ),

          // Back button positioned at top left
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.black87, size: 28),
            ),
          ),

          // Contenu du formulaire
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 100),
                const Text(
                  'Verification code',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Text(
                  'We have sent you a code\nto verify your phone number',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // ✅ 6 champs au lieu de 4
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 45,
                      height: 65,
                      child: TextField(
                        controller: _controllers[index],
                        autofocus: index == 0,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: const Color(0xFFFDF6D8),
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          if (value.length == 1 && index < 5) {
                            FocusScope.of(context).nextFocus();
                          }
                          if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 30),

                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 16),
                    children: [
                      TextSpan(
                        text: "Didn't receive anything? ",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'Send again',
                        style: TextStyle(
                          color: Color(0xFFEAB308),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Bouton Verify
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        print(widget.email);
                        int? otp = getOtpAsInt();
                        print(otp);
                        if (otp == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a valid 6-digit OTP'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          Map<String, dynamic> creds = {
                            'email': widget.email,
                            'otp': "$otp",
                          };
                          print(creds);
                          bool verf = await Auth.verify_otp(context, creds);
                          if (verf) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('OTP verified successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeEmployee(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Verification failed '),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[600], // Amber 600
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Verify',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
