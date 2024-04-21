import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/Employee%20Management/Employees.dart';
import 'package:mobile_app/project%20management/gestion%20de%20projet/addproject.dart';
import 'package:mobile_app/project%20management/gestion%20de%20projet/listeProjet.dart';
import 'package:mobile_app/project%20management/gestion%20de%20projet/project.dart';

class ProjectManagementDetails extends StatefulWidget {
  @override
  _ProjectManagementDetailsState createState() =>
      _ProjectManagementDetailsState();
}

class _ProjectManagementDetailsState extends State<ProjectManagementDetails> {
  bool isAdmin =
      true; // This should ideally be determined by the current user's role
  Employee? currentUser;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initUser();
  }

  Future<void> _initUser() async {
    try {
      var user =
          await getCurrentUser(); // Make sure this method is implemented to fetch the current user
      setState(() {
        currentUser = user;
        isAdmin = user.jobTitle.toLowerCase() == "admin";
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Projects', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF6D42CE),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _navigateToAddProject(context),
          ),
        ],
      ),
      body: currentUser == null
          ? Center(child: Text("No user found"))
          : ListView.builder(
              itemCount: ListeProjet.projects.length,
              itemBuilder: (context, index) {
                final Project project = ListeProjet.projects[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: buildProjectListTile(project),
                );
              },
            ),
    );
  }

  Widget buildProjectListTile(Project project) {
    Employee? creator = getMockEmployees().firstWhere(
      (emp) => emp.name == project.createdBy,
      orElse: () => Employee(
        firstName: 'Unknown',
        lastName: '',
        email: 'N/A',
        jobTitle: 'N/A',
        phoneNumber: 'N/A',
        country: 'N/A',
        language: 'N/A',
        imagePath: 'assets/placeholder.png',
        name: 'Unknown',
      ),
    );

    return ListTile(
      title: Text(project.title),
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ProjectDetails(project: project),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0), // Right to left
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ));
      },
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Start Date: ${project.startDate}'),
          Text('End Date: ${project.endDate}'),
          Text('Created By: ${creator.name}'),
          LinearProgressIndicator(value: project.progress / 100),
        ],
      ),
      trailing: canModifyProject(project)
          ? Container(width: 100, child: _buildActionButtons(project))
          : null,
    );
  }

  Widget _buildActionButtons(Project project) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.edit, color: Colors.blue),
          tooltip: 'Edit Project',
          onPressed: () {
            // Implement edit functionality
          },
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          tooltip: 'Delete Project',
          onPressed: () => _confirmDeletion(project),
        ),
      ],
    );
  }

  void _confirmDeletion(Project project) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text(
              'Are you sure you want to delete the project: ${project.title}?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                // Implement your deletion logic here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool canModifyProject(Project project) {
    if (currentUser == null) {
      print("currentUser is null");
      return false;
    }
    print(
        "currentUser jobTitle: ${currentUser?.jobTitle}"); // Check what job title is being received
    String jobTitleLower = currentUser!.jobTitle.toLowerCase();
    bool canModify =
        jobTitleLower == 'admin' || jobTitleLower == 'project management';
    print("Can modify: $canModify"); // Check if this returns true when expected
    return canModify;
  }
}

void _navigateToAddProject(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => AddProjectPage()),
  );
}
