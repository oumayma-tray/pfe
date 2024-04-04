import 'package:flutter/material.dart';
import 'package:mobile_app/Project Management/Employees.dart';

class EmployeeDetailsPage extends StatelessWidget {
  final Employee employee;

  EmployeeDetailsPage({Key? key, required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Size calculation for responsive design
    double width = MediaQuery.of(context).size.width * 1; // 80% of screen width
    double imageRadius = width * 0.15; // 15% of allocated width for the image
    double editButtonWidth =
        width * 0.45; // 45% of allocated width for the edit button
    double editButtonHeight =
        imageRadius * 0.8; // 60% of the image radius for button height

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF9155FD), Color(0xFFC5A5FE)],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 50),
                Image.asset('assets/smartovate.png',
                    height: 100), // Company logo
                SizedBox(height: 30),
                CircleAvatar(
                  backgroundImage: AssetImage(employee.imagePath),
                  radius: imageRadius, // Dynamic size based on screen width
                ),
                SizedBox(height: 20),
                Text(employee.name,
                    style: Theme.of(context).textTheme.headline5),
                Text('Details', style: Theme.of(context).textTheme.subtitle1),
                SizedBox(height: 20),
                Container(
                  width: width, // Dynamic width based on screen size
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0x40000000), // Semi-transparent black
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildDetailRow('Username', employee.name),
                      _buildDetailRow('First Name', employee.firstName),
                      _buildDetailRow('Last Name', employee.lastName),
                      _buildDetailRow('Email', employee.email),
                      _buildDetailRow('Phone', employee.phoneNumber),
                      _buildDetailRow('Country', employee.country),
                      _buildDetailRow('Job Title', employee.jobTitle),
                      _buildDetailRow('Language', employee.language),
                    ],
                  ),
                ),
                Container(
                  width: editButtonWidth, // Dynamic width based on screen size
                  height:
                      editButtonHeight, // Dynamic height based on image radius
                  margin: EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement the navigation to the edit screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF28243D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                        ),
                      ),
                    ),
                    child: Text(
                      'EDIT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50), // Provide spacing at the end of the page
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          children: [
            TextSpan(
              text: value,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
