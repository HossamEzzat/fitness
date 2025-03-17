import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/Auth/login.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String? _gender;
  DateTime? _dateOfBirth;
  String? _activityLevel;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'email': _emailController.text,
          'gender': _gender,
          'date_of_birth': _dateOfBirth?.toIso8601String(),
          'weight': _weightController.text,
          'height': _heightController.text,
          'activity_level': _activityLevel,
          'uid': userCredential.user!.uid,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User Registered Successfully!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration Failed: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000022),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50),
                Text('Create an Account', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 30),
                _buildTextField(_firstNameController, 'First Name', Icons.person),
                SizedBox(height: 16),
                _buildTextField(_lastNameController, 'Last Name', Icons.person_outline),
                SizedBox(height: 16),
                _buildTextField(_emailController, 'Email', Icons.email),
                SizedBox(height: 16),
                _buildTextField(_passwordController, 'Password', Icons.lock, isPassword: true),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  dropdownColor: Colors.black,
                  value: _gender,
                  items: ['Male', 'Female', 'Other'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(color: Colors.white)))).toList(),
                  onChanged: (val) => setState(() => _gender = val),
                  decoration: _inputDecoration('Choose Gender', Icons.wc),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
                    if (picked != null) setState(() => _dateOfBirth = picked);
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: _inputDecoration(_dateOfBirth == null ? 'Date of Birth' : _dateOfBirth!.toLocal().toString().split(' ')[0], Icons.calendar_today),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextField(_weightController, 'Your Weight', Icons.fitness_center)),
                    Text('KG', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextField(_heightController, 'Your Height', Icons.height)),
                    Text('CM', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  dropdownColor: Colors.black,
                  value: _activityLevel,
                  items: ['Low', 'Medium', 'High'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(color: Colors.white)))).toList(),
                  onChanged: (val) => setState(() => _activityLevel = val),
                  decoration: _inputDecoration('Activity', Icons.directions_run),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _registerUser,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                  child: Text('Register', style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon, {bool isPassword = false}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      prefixIcon: Icon(icon, color: Colors.grey),
      suffixIcon: isPassword
          ? IconButton(
        icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
        onPressed: _togglePasswordVisibility,
      )
          : null,
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? !_isPasswordVisible : false,
      style: TextStyle(color: Colors.white),
      decoration: _inputDecoration(label, icon, isPassword: isPassword),
      validator: (value) => value!.isEmpty ? '$label is required' : null,
    );
  }
}