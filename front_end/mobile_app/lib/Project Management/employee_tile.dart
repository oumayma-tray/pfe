import 'package:flutter/material.dart';
import 'package:mobile_app/Project Management/Employees.dart';
import 'package:mobile_app/Project%20Management/EmployeeDetails.dart';
import 'package:mobile_app/Project%20Management/addEmployee.dart';
import 'package:mobile_app/Project%20Management/updateEmployee.dart';

class EmployeeDirectoryPage extends StatefulWidget {
  @override
  _EmployeeDirectoryPageState createState() => _EmployeeDirectoryPageState();
}

class _EmployeeDirectoryPageState extends State<EmployeeDirectoryPage> {
  final int itemsPerPage = 10;
  int currentPage = 1;
  late List<Employee>
      employees; // Consider initializing employees in the initState
  late List<Employee> filteredEmployees; // Same for filteredEmployees
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    employees =
        getMockEmployees(); // Call this first to ensure employees are populated.
    filteredEmployees = List.from(
        employees); // Then initialize filteredEmployees with employees.
    searchController = TextEditingController();
    searchController.addListener(() {
      filterEmployeesByName(
          searchController.text); // Filter whenever the text changes.
    });
  }

  @override
  void dispose() {
    searchController.removeListener(() {
      filterEmployeesByName(searchController.text);
    });
    searchController.dispose(); // Dispose of the text controller.
    super.dispose();
  }

  void filterEmployeesByName(String query) {
    if (query.isNotEmpty) {
      final queryLower = query.toLowerCase();
      setState(() {
        filteredEmployees = employees
            .where(
                (employee) => employee.name.toLowerCase().contains(queryLower))
            .toList();
      });
    } else {
      setState(() {
        filteredEmployees = List.from(employees);
      });
    }
  }

  List<Employee> get paginatedFilteredEmployees {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    endIndex = endIndex > filteredEmployees.length
        ? filteredEmployees.length
        : endIndex;
    return filteredEmployees.sublist(startIndex, endIndex);
  }

  void goToNextPage() {
    if ((currentPage * itemsPerPage) < filteredEmployees.length) {
      setState(() {
        currentPage++;
      });
    }
  }

  void goToPreviousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
    }
  }

  // You might have a list of employees data to display
  // For demonstration, it's just empty

  @override
  Widget build(BuildContext context) {
    // Assuming you have a controller for your search bar
    final searchController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // This is set to avoid resizing the screen when the keyboard opens.
      body: SingleChildScrollView(
        // This makes the whole screen scrollable.
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF9155FD), Color(0xFFC5A5FE)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Image.asset('assets/smartovate.png', height: 50),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: searchController,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search (Ctrl+/)',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    prefixIcon:
                        Icon(Icons.search, color: Colors.white, size: 20),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                          color: Colors
                              .white), // White border for default/normal state
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                          color:
                              Colors.white), // White border for focused state
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Employees',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => addEmployeeScreen()),
                  );
                },
                //... ElevatedButton style
                child: Text('ADD EMPLOYEE'),
              ),
              Image.asset('assets/SEO.png'), // Remove the Expanded widget here.
              Container(
                color: Color(0xFF28243D),
                child: Column(
                  children: [
                    EmployeeHeader(), // Your employee list header
                    ListView.builder(
                      primary:
                          false, // Setting this to false in a SingleChildScrollView to disable scrolling.
                      shrinkWrap:
                          true, // Shrink-wrapping the content of the ListView.
                      itemCount: paginatedFilteredEmployees.length,
                      itemBuilder: (context, index) {
                        return EmployeeRow(
                            employee: paginatedFilteredEmployees[index]);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: goToPreviousPage,
                          tooltip: 'Previous page',
                        ),
                        Text('Page $currentPage'),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: goToNextPage,
                          tooltip: 'Next page',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmployeeRow extends StatelessWidget {
  final Employee employee;

  EmployeeRow({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF28243D),
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(employee.imagePath), // Load the image
            radius: 20.0, // You can adjust the radius as needed
          ),
          // Create a method to build the detail box
          _buildDetailBox(employee.name),
          _buildDetailBox(employee.email),
          _buildDetailBox(employee.jobTitle),
          _buildDetailBox(employee.phoneNumber),
          _buildDetailBox(employee.country),
          CustomPopupMenuButton(
            onSelected: (value) {
              _handleMenuItemSelected(context, value);
            },
          ),
        ],
      ),
    );
  }

  void _handleMenuItemSelected(BuildContext context, String value) {
    switch (value) {
      case 'View':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmployeeDetailsPage(employee: employee),
          ),
        );
        break;
      case 'Edit':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateEmployeePage(employee: employee),
          ),
        ).catchError((error) {
          print('Navigation error: $error');
        });

        break;
      case 'Delete':
        // Handle delete operation here
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirm Delete"),
              content: Text("Are you sure you want to delete this employee?"),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text("Delete"),
                  onPressed: () {
                    // Implement delete logic here
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        break;
      default:
        break;
    }
  }

  Widget _buildDetailBox(String text) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF9155FD), Color(0xFFC5A5FE)],
          ),
          borderRadius: BorderRadius.circular(5), // Rounded corners
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class EmployeeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      color: Color(0xFF28243D),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
              child: Text('Employee', style: TextStyle(color: Colors.white))),
          Expanded(child: Text('Email', style: TextStyle(color: Colors.white))),
          Expanded(
              child: Text('Job Title', style: TextStyle(color: Colors.white))),
          Expanded(
              child:
                  Text('Phone Number', style: TextStyle(color: Colors.white))),
          Expanded(
              child: Text('Country', style: TextStyle(color: Colors.white))),
          Expanded(
              child: Text('Actions',
                  style: TextStyle(
                      color: Colors.white))), // Placeholder for action icon
        ],
      ),
    );
  }
}

// A callback function type definition for menu item selection
typedef MenuItemCallback = void Function(String value);

class CustomPopupMenuButton extends StatelessWidget {
  final MenuItemCallback onSelected;

  CustomPopupMenuButton({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.more_vert, color: Colors.white),
      onPressed: () {
        // The menu is shown when the button is tapped
        _showCustomMenu(context);
      },
    );
  }

  // Function to show the menu
  void _showCustomMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    // Build and show the menu
    showMenu(
      context: context,
      position: position,
      items: [
        _buildPopupMenuItem(context, 'View', 'assets/view.png'),
        _buildPopupMenuItem(context, 'Edit', 'assets/edit.png'),
        _buildPopupMenuItem(context, 'Delete', 'assets/delate.png'),
      ],
      color: Color(0xFF28243D),
    ).then((value) {
      // Handle the action when an item is selected
      if (value != null) {
        onSelected(value);
      }
    });
  }

  // Function to build an individual menu item
  PopupMenuItem<String> _buildPopupMenuItem(
      BuildContext context, String value, String asset) {
    return PopupMenuItem<String>(
      value: value,
      child: ListTile(
        leading: Image.asset(asset, width: 24, height: 24),
        title: Text(value, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
