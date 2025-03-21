import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart'; // Assuming you have a login page

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String? _gender;
  DateTime? _dateOfBirth;

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  double _calculateBmr(double weight, double height, int age, String gender) {
    if (gender == 'Male') {
      return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      return 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        int age = DateTime.now().year - _dateOfBirth!.year;
        double weight = double.parse(_weightController.text);
        double height = double.parse(_heightController.text);
        double bmr = _calculateBmr(weight, height, age, _gender!);

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'email': _emailController.text,
          'gender': _gender,
          'weight': weight,
          'height': height,
          'age': age,
          'bmr': bmr,
          'uid': userCredential.user!.uid,
        });

        // Save BMR to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setDouble('bmr', bmr);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Registration Successful'),
            content: Text('Your BMR is ${bmr.toStringAsFixed(2)} kcal/day.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration Failed: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
        height: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff000022), Color(0xff000033)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Text(
                      'Create an Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    _buildTextField(_firstNameController, 'First Name', Icons.person),
                    SizedBox(height: 16),
                    _buildTextField(_lastNameController, 'Last Name', Icons.person_outline),
                    SizedBox(height: 16),
                    _buildTextField(_emailController, 'Email', Icons.email),
                    SizedBox(height: 16),
                    _buildTextField(_passwordController, 'Password', Icons.lock, isPassword: true),
                    SizedBox(height: 16),
                    _buildTextField(_weightController, 'Weight (kg)', Icons.fitness_center, isNumber: true),
                    SizedBox(height: 16),
                    _buildTextField(_heightController, 'Height (cm)', Icons.height, isNumber: true),
                    SizedBox(height: 16),
                    _buildGenderDropdown(),
                    SizedBox(height: 16),
                    _buildDateOfBirthField(),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff73C254),
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false, bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? !_isPasswordVisible : false,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
          onPressed: _togglePasswordVisibility,
        )
            : null,
      ),
      validator: (value) => value!.isEmpty ? '$label is required' : null,
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _gender,
      items: ['Male', 'Female']
          .map((e) => DropdownMenuItem(
        value: e,
        child: Text(
          e,
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
      ))
          .toList(),
      onChanged: (val) => setState(() => _gender = val),
      decoration: InputDecoration(
        labelText: 'Gender',
        labelStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(Icons.wc, color: Colors.grey),
      ),
      style: TextStyle(color: Colors.white), // Ensure the selected text is also white
      dropdownColor: Colors.black, // Set the background color of the dropdown items
      validator: (value) => value == null ? 'Gender is required' : null,
    );
  }

  Widget _buildDateOfBirthField() {
    return GestureDetector(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) setState(() => _dateOfBirth = picked);
      },
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Date of Birth',
            labelStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(Icons.calendar_today, color: Colors.grey),
          ),
          controller: TextEditingController(
              text: _dateOfBirth == null ? '' : _dateOfBirth!.toLocal().toString().split(' ')[0]),
          style: TextStyle(color: Colors.white),
          validator: (value) => value!.isEmpty ? 'Date of Birth is required' : null,
        ),
      ),
    );
  }
}