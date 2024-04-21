import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/project%20management/gestion%20de%20projet/listeProjet.dart';

class PlanningDetails extends StatelessWidget {
  final String currentUserID; // ID of the logged-in user

  PlanningDetails({Key? key, required this.currentUserID}) : super(key: key);

  List<Widget> buildTasksList() {
    var tasks = ListeProjet.projects
        .expand((project) =>
            project.tasks.where((task) => task.assignedTo == currentUserID))
        .toList();

    if (tasks.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text("No tasks assigned to you yet.",
              style: GoogleFonts.roboto(fontSize: 18, color: Colors.black)),
        ),
      ];
    }

    return tasks
        .map((task) => ListTile(
              title: Text(task.name,
                  style: GoogleFonts.roboto(fontSize: 18, color: Colors.black)),
              subtitle: Text(task.dueDate,
                  style: GoogleFonts.roboto(color: Colors.black)),
              leading: Icon(Icons.check_circle,
                  color: task.isCompleted ? Colors.green : Colors.red),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.checklist, color: Colors.grey),
                  Text(
                      '${task.completedSubtasksCount}/${task.subtasks.length}'),
                ],
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks', style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xFF6D42CE),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: buildTasksList(),
        ),
      ),
    );
  }
}
