import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/Employee%20Management/Employees.dart'; // Ensure the import path matches your project structure

class AddProjectPage extends StatefulWidget {
  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final _formKey = GlobalKey<FormState>();
  String? _title, _startDate, _endDate;
  List<Employee> employees = getMockEmployees(); // Get the list of employees
  List<Employee> _selectedEmployees = [];
  // To store the selected employee names

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Project'),
        backgroundColor: Color(0xFF6D42CE),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Project Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter project title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Start Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter start date';
                  }
                  return null;
                },
                onSaved: (value) => _startDate = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'End Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter end date';
                  }
                  return null;
                },
                onSaved: (value) => _endDate = value,
              ),
              ElevatedButton(
                onPressed: _showEmployeePicker,
                child: Text('Add Employees'),
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Create Project'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Here, you would handle the project creation logic including the selected employees
      // Example: Save to database or send to server
      print("Selected Employees: $_selectedEmployees");
      Navigator.of(context).pop(); // Optionally pop the context after creation
    }
  }

  void _showEmployeePicker() {
    // Create a local copy of selected employees for use within the dialog
    List<Employee> localSelectedEmployees =
        List<Employee>.from(_selectedEmployees);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Employees'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) {
              return Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: employees.length,
                  itemBuilder: (BuildContext context, int index) {
                    bool isSelected =
                        localSelectedEmployees.contains(employees[index]);
                    return CheckboxListTile(
                      title: Text(employees[index].name),
                      subtitle: Text(employees[index].jobTitle),
                      secondary: CircleAvatar(
                        backgroundImage: AssetImage(employees[index].imagePath),
                      ),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setStateDialog(() {
                          if (value == true) {
                            if (!localSelectedEmployees
                                .contains(employees[index])) {
                              localSelectedEmployees.add(employees[index]);
                            }
                          } else {
                            localSelectedEmployees
                                .removeWhere((emp) => emp == employees[index]);
                          }
                        });
                      },
                    );
                  },
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  _selectedEmployees = localSelectedEmployees;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
