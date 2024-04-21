import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/Employee%20Management/Employees.dart';
import 'package:mobile_app/project%20management/gestion%20de%20projet/listeProjet.dart';

class AddProjectPage extends StatefulWidget {
  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final _formKey = GlobalKey<FormState>();
  String? _title, _startDate, _endDate;
  List<Employee> employees = getMockEmployees();
  List<Employee> _selectedEmployees = [];
  Employee? _selectedEmployee;

  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDueDateController = TextEditingController();
  List<Task> _tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Project', style: GoogleFonts.roboto()),
        backgroundColor: Color(0xFF6D42CE),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Project Title',
                  icon: Icon(Icons.title),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter project title' : null,
                onSaved: (value) => _title = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  icon: Icon(Icons.date_range),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter start date' : null,
                onSaved: (value) => _startDate = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'End Date',
                  icon: Icon(Icons.date_range),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter end date' : null,
                onSaved: (value) => _endDate = value,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Add Employees'),
                onPressed: _showEmployeePicker,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffC5A5FE), // Button color
                  shadowColor: Colors.white, // Text color
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.add_task),
                label: Text('Add Task'),
                onPressed: () => _showTaskDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffC5A5FE), // Button color
                  shadowColor: Colors.white, // Text color
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text('Create Project'),
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffC5A5FE), // Button color
                  shadowColor: Colors.white, // Text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Assuming Project constructor correctly handles all fields
      Project newProject = Project(
        title: _title!,
        startDate: _startDate!,
        endDate: _endDate!,
        createdBy: 'Admin', // Placeholder for the creator
        tasks: _tasks,
        employees: _selectedEmployees,
        assignedEmployees: [], // This should be a part of your Project model
      );

      ListeProjet.projects
          .add(newProject); // Assuming this is your global project list

      print("Project Added: ${newProject.title}");
      Navigator.of(context).pop(); // Close the screen after adding the project
    }
  }

  void _showEmployeePicker() {
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
                    return CheckboxListTile(
                      title: Text(employees[index].name),
                      subtitle: Text(employees[index].jobTitle),
                      secondary: CircleAvatar(
                        backgroundImage: AssetImage(employees[index].imagePath),
                      ),
                      value: localSelectedEmployees.contains(employees[index]),
                      onChanged: (bool? value) {
                        setStateDialog(() {
                          if (value!) {
                            localSelectedEmployees.add(employees[index]);
                          } else {
                            localSelectedEmployees.remove(employees[index]);
                          }
                        });
                      },
                    );
                  },
                ),
              );
            },
          ),
          actions: [
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

  void _addTask() {
    Task newTask = Task(
      name: _taskNameController.text,
      dueDate: _taskDueDateController.text,
      isCompleted: false,
      assignedTo: 'Assigned Employee ID or Name', // Adjust as needed
    );
    setState(() {
      _tasks.add(newTask);
      _taskNameController.clear();
      _taskDueDateController.clear();
    });
  }

  void _showTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _taskNameController,
                  decoration: InputDecoration(labelText: 'Task Name'),
                ),
                TextField(
                  controller: _taskDueDateController,
                  decoration: InputDecoration(labelText: 'Due Date'),
                ),
                DropdownButton<Employee>(
                  value: _selectedEmployee,
                  hint: Text('Assign to'),
                  onChanged: (Employee? newValue) {
                    setState(() {
                      _selectedEmployee = newValue;
                    });
                  },
                  items: _selectedEmployees
                      .map<DropdownMenuItem<Employee>>((Employee employee) {
                    return DropdownMenuItem<Employee>(
                      value: employee,
                      child: Text(employee.name),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Add Task'),
              onPressed: () {
                if (_taskNameController.text.isNotEmpty &&
                    _taskDueDateController.text.isNotEmpty &&
                    _selectedEmployee != null) {
                  Task newTask = Task(
                    name: _taskNameController.text,
                    dueDate: _taskDueDateController.text,
                    assignedTo: _selectedEmployee!
                        .name, // Ensure Employee has a 'name' property
                  );
                  setState(() {
                    _tasks.add(newTask);
                    _taskNameController.clear();
                    _taskDueDateController.clear();
                    _selectedEmployee =
                        null; // Reset the selected employee after adding a task
                  });
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
            ),
          ],
        );
      },
    );
  }
}
