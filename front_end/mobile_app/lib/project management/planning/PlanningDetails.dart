import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/project%20management/gestion%20de%20projet/listeProjet.dart';

class PlanningDetails extends StatefulWidget {
  final String currentUserID;

  PlanningDetails({Key? key, required this.currentUserID}) : super(key: key);

  @override
  _PlanningDetailsState createState() => _PlanningDetailsState();
}

class _PlanningDetailsState extends State<PlanningDetails> {
  late List<Task> filteredTasks;
  @override
  void initState() {
    super.initState();
    filteredTasks = _getAllTasks(); // Start with all tasks
  }

  List<Task> _getAllTasks() {
    return ListeProjet.projects
        .expand((project) => project.tasks)
        .where((task) => task.assignedTo == widget.currentUserID)
        .toList();
  }

  List<Task> _getInProgressTasks() {
    return _getAllTasks()
        .where(
            (task) => !task.isCompleted) // Check if the task is not completed.
        .toList();
  }

  List<Task> _getCompletedTasks() {
    // Retrieve all tasks that are assigned to the current user and that meet the completion criteria.
    var completedTasks = _getAllTasks().where((task) {
      // Check if the task is marked as completed and all its subtasks are also completed.
      bool allSubtasksCompleted =
          task.subtasks.every((subtask) => subtask.isCompleted);
      return task.isCompleted && allSubtasksCompleted;
    }).toList();

    // Debug output to verify the functionality.
    print("Completed tasks count: ${completedTasks.length}");
    completedTasks.forEach((task) => print("Completed Task: ${task.name}"));

    return completedTasks;
  }

  List<Widget> buildTasksList(BuildContext context) {
    var tasks = ListeProjet.projects
        .expand((project) => project.tasks
            .where((task) => task.assignedTo == widget.currentUserID))
        .toList();

    if (filteredTasks.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text("No tasks assigned to you yet.",
              style: GoogleFonts.roboto(fontSize: 18, color: Colors.black)),
        ),
      ];
    }

    return filteredTasks
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
              onTap: () => navigateToTaskDetails(context, task),
            ))
        .toList();
  }

  void navigateToTaskDetails(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TaskDetailsScreen(task: task)),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Tasks'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('In Progress'),
                onTap: () {
                  setState(() {
                    filteredTasks = _getInProgressTasks();
                  });
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              ListTile(
                title: Text('Completed'),
                onTap: () {
                  setState(() {
                    filteredTasks = _getCompletedTasks();
                  });
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks', style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xFF6D42CE),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _showFilterOptions(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: buildTasksList(context),
        ),
      ),
    );
  }
}

class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  TaskDetailsScreen({Key? key, required this.task}) : super(key: key);

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.name),
        backgroundColor: Color(0xFF6D42CE),
      ),
      body: ListView(
        children: widget.task.subtasks.map((subtask) {
          return ListTile(
            title: Text(subtask.name),
            leading: Icon(
              subtask.isCompleted
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
            ),
            onTap: () {
              setState(() {
                subtask.isCompleted = !subtask.isCompleted;
              });
              // If using a provider or other state management, you would call that here
              // Also, if you have a backend, you would send the update to the server
            },
          );
        }).toList(),
      ),
    );
  }
}
