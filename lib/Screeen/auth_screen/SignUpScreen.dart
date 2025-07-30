import 'package:flutter/material.dart';
import 'package:screen_page/Screeen/auth_screen/Otpscreen.dart';
import 'package:screen_page/service/Auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _FullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _showValidationErrors = false;

  // Password visibility state
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFBEA), // Light warm yellow background
      body: Stack(
        children: [
          Positioned(
            top: -70,
            right: -50,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: Color(0xFFEAB308), // Golden Yellow
            ),
          ),
          Positioned(
            top: -70,
            left: -50,
            child: CircleAvatar(
              radius: 200,
              backgroundColor: Color.fromARGB(
                255,
                235,
                207,
                85,
              ).withOpacity(0.3), // Soft yellow-orange
            ),
          ),
          Positioned(
            top: -30,
            right: -30,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Color.fromARGB(
                255,
                235,
                223,
                146,
              ).withOpacity(0.5), // Deeper yellow
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Create your account",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField("Full Name", _FullNameController),
                      _buildTextField(
                        "Phone number",
                        _phoneController,
                        isPhone: true,
                      ),
                      _buildTextField("Email", _emailController, isEmail: true),

                      _buildTextField(
                        "Password",
                        _passwordController,
                        isPassword: true,
                        isPasswordVisible: _isPasswordVisible,
                        toggleVisibility: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      _buildTextField(
                        "Confirm password",
                        _confirmPasswordController,
                        isPassword: true,
                        isPasswordVisible: _isConfirmPasswordVisible,
                        toggleVisibility: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _showValidationErrors = true;
                            });
                            if (_formKey.currentState!.validate()) {
                              Map<String, dynamic> creds = {
                                "fullName": _FullNameController.text,
                                "email": _emailController.text,
                                "phone": _phoneController.text,
                                "password": _passwordController.text,
                                "confirmPassword":
                                    _confirmPasswordController.text,
                              };
                              await Auth.singup(creds, context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => Otpscreen(
                                        email: _emailController.text,
                                      ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: Colors.amber[600], // Amber 600
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Sign up",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    bool isPassword = false,
    bool isEmail = false,
    bool isPhone = false,
    bool isPasswordVisible = false,
    VoidCallback? toggleVisibility,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? !isPasswordVisible : false,
        keyboardType:
            isEmail
                ? TextInputType.emailAddress
                : isPhone
                ? TextInputType.phone
                : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Color(0xFFFDF6D8), // Very light yellow for fields
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Color(0xFFEAB308), // Icon color match
                    ),
                    onPressed: toggleVisibility,
                  )
                  : null,
        ),
        validator: (value) {
          if (_showValidationErrors && (value == null || value.isEmpty)) {
            return "Please enter your $hint";
          }
          return null;
        },
      ),
    );
  }
}
