import 'package:flutter/material.dart';
import 'package:mobile_app/Employee%20Management/Employees.dart';

class UpdateEmployeePage extends StatefulWidget {
  final Employee employee; // Pass the employee object that will be edited.

  UpdateEmployeePage({required this.employee});

  @override
  _UpdateEmployeePageState createState() => _UpdateEmployeePageState();
}

class _UpdateEmployeePageState extends State<UpdateEmployeePage> {
  String? selectedRole; // Declaring with an explicit type
// Declaring with type inference

  late String? selectedLanguage;
  final List<String> roles = ['Admin', 'User', 'Viewer'];
  final List<String> languages = ['English', 'French', 'Spanish'];

  // Text editing controllers to hold and manage form field contents
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController countryController;
  late TextEditingController phoneNumberController;
  late TextEditingController jobTitleController;

  @override
  void initState() {
    super.initState();
    selectedRole = roles.contains(widget.employee.role)
        ? widget.employee.role
        : roles.first;
    // Initialize the controllers with existing data

    nameController = TextEditingController(text: widget.employee.name);
    emailController = TextEditingController(text: widget.employee.email);
    firstNameController =
        TextEditingController(text: widget.employee.firstName);
    lastNameController = TextEditingController(text: widget.employee.lastName);
    countryController = TextEditingController(text: widget.employee.country);
    phoneNumberController =
        TextEditingController(text: widget.employee.phoneNumber);
    jobTitleController = TextEditingController(text: widget.employee.jobTitle);
    selectedRole = roles.contains(widget.employee.role)
        ? widget.employee.role
        : roles.first;
    selectedLanguage = languages.contains(widget.employee.language)
        ? widget.employee.language
        : languages.first;
    selectedLanguage = widget.employee.language;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9155FD), // Page background color
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/smartovate.png', height: 100), // Company Logo
              _buildSection('1. Account Details'),
              _buildTextField('Username', nameController),
              _buildTextField('Email', emailController),
              _buildDropdown('Select Role', roles, selectedRole),

              _buildSection('2. Personal Info'),
              _buildTextField('First Name', firstNameController),
              _buildTextField('Last Name', lastNameController),
              _buildTextField('Country', countryController),
              _buildDropdown('Language', languages, selectedLanguage),
              _buildTextField('Phone Number', phoneNumberController),
              _buildTextField('Job Title', jobTitleController),
              _buildSubmitButton(),
              SizedBox(height: 20), // Space at the end of the form
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                    widget.employee.imagePath), // Employee image at the bottom
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          filled: true,
          fillColor: Color(0x40000000), // Semi-transparent black
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildDropdown(
      String hintText, List<String> options, String? selectedValue) {
    // Ensure that selectedValue is either null or a value that exists in the options list
    assert(selectedValue == null || options.contains(selectedValue));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Color(0x40000000), // Semi-transparent black
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            hint: Text(selectedValue ?? hintText,
                style: TextStyle(color: Colors.white.withOpacity(0.7))),
            dropdownColor: Color(0xFF6D42CE),
            value: selectedValue,
            icon: Icon(Icons.arrow_drop_down, color: Colors.white),
            isExpanded: true,
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                if (options == roles) {
                  selectedRole = newValue;
                } else if (options == languages) {
                  selectedLanguage = newValue;
                }
              });
            },
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Submit updated employee data logic
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF9155FD), Color(0xFFC5A5FE)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            alignment: Alignment.center,
            constraints: const BoxConstraints(minHeight: 50.0),
            child: const Text(
              'UPDATE',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    countryController.dispose();
    phoneNumberController.dispose();
    jobTitleController.dispose();
    super.dispose();
  }
}
