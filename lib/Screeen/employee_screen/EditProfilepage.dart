import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_page/Model/User.dart';
import 'package:screen_page/Provider/UserProvider.dart';

class Editprofilpage extends StatefulWidget {
  const Editprofilpage({super.key});
  @override
  State<Editprofilpage> createState() => _EditprofilpageState();
}

class _EditprofilpageState extends State<Editprofilpage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController(
    text: "Mohamed Lakhder",
  );

  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    User user = Provider.of<UserProvider>(context, listen: false).get_user;

    nameController.text = user.name;
    emailController.text = user.email;
    nameController.addListener(_checkChanges);
    emailController.addListener(_checkChanges);
    passwordController.addListener(_checkChanges);
  }

  void _checkChanges() {
    final newState =
        nameController.text != "Mohamed " ||
        emailController.text != "john.smith@example.com" ||
        passwordController.text != "Mohamed ";

    if (newState != _hasChanges) {
      setState(() {
        _hasChanges = newState;
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final userProfile = {
        'fullName': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      };
      print(userProfile);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Changes saved successfully'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.asset(
                            "assets/Images/avtarImag.jpg",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Change picteur",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor:
                                Colors.yellow[700], // 🌟 Yellow background
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    _sectionTitle("Personal Information"),
                    _inputField("Full Name", nameController),
                    _inputField("Email", emailController, isEmail: true),
                    const SizedBox(height: 20),
                    _sectionTitle("Security Information"),
                    _inputField("Password", passwordController, obscure: true),

                    const SizedBox(height: 80), // Space for the button
                  ],
                ),
              ),
            ),
          ),

          // Save Button Container
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _hasChanges ? _saveProfile : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _inputField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
    bool isEmail = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              if (isEmail && !value.contains('@')) {
                return 'Invalid email address';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
