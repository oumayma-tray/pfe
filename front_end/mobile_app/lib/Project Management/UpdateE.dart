import 'package:flutter/material.dart';

class UpdateEmployeeScreen extends StatefulWidget {
  @override
  _UpdateEmployeeScreenState createState() => _UpdateEmployeeScreenState();
}

class _UpdateEmployeeScreenState extends State<UpdateEmployeeScreen> {
  String? selectedRole; // Field to track the selected role
  String? selectedLanguage; // Field to track the selected language
  final List<String> roles = ['Admin', 'User', 'Viewer'];
  final List<String> languages = ['English', 'French', 'Spanish'];

  @override
  void initState() {
    super.initState();
    selectedRole = null; // Start with no role selected
    selectedLanguage = null; // Start with no language selected
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
              _buildTextField('Username'),
              _buildTextField('Email'),
              _buildDropdown('Select Role', roles, selectedRole),

              _buildSection('2. Personal Info'),
              _buildTextField('First Name'),
              _buildTextField('Last Name'),
              _buildTextField('Country'),
              _buildDropdown('Language', languages, selectedLanguage),
              _buildTextField('Phone Number'),
              _buildTextField('Job Title'),
              _buildSubmitButton(),
              SizedBox(height: 20), // Space at the end of the form
              Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                    'assets/Uemployee.png'), // Employee image at the bottom
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

  Widget _buildTextField(String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
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
            hint: Text(hintText,
                style: TextStyle(color: Colors.white.withOpacity(0.7))),
            dropdownColor: Color(0xFF6D42CE),
            value: selectedValue, // Use the selectedValue for the state
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
                if (hintText == 'Select Role') {
                  selectedRole = newValue;
                } else if (hintText == 'Language') {
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
          // Submit logic
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
              'SUBMIT',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
