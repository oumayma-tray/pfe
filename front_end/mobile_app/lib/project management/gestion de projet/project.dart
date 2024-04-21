import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/project%20management/gestion%20de%20projet/Project.dart';
import 'package:mobile_app/project%20management/gestion%20de%20projet/listeProjet.dart'; // Ensure you have the correct import for Project

class ProjectDetails extends StatefulWidget {
  final Project project;

  ProjectDetails({Key? key, required this.project}) : super(key: key);

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  List<Task> _userTasks = [];
  bool _showUserTasks = false;
  @override
  void initState() {
    super.initState();
    _filterUserTasks();
  }

  void _filterUserTasks() {
    setState(() {
      // Replace 'currentUser' with the actual user identifier of the logged-in user.
      // For example, if you store the logged-in user details in a User object,
      // you would compare task.assignedTo with User.id or a similar property.
      String currentUser = "oumayma"; // Get the current user's id
      _userTasks = widget.project.tasks.where((task) {
        return task.assignedTo == currentUser;
      }).toList();
    });
  }

  void _onMenuSelected(String value) {
    switch (value) {
      case 'Edit':
        // Handle edit action
        break;
      case 'Delete':
        // Handle delete action
        break;
      case 'My Tasks':
        setState(() {
          _showUserTasks = true;
          _filterUserTasks(); // Filter tasks when 'My Tasks' is selected
        });
        break;
    }
  }

  void _updateTaskCompletion(Task task, bool isCompleted) {
    setState(() {
      // Find the task and update its completion status
      final int taskIndex = widget.project.tasks.indexOf(task);
      if (taskIndex != -1) {
        widget.project.tasks[taskIndex].isCompleted = isCompleted;
      }

      // Recalculate the project progress
      widget.project.updateTask(widget.project.tasks[taskIndex]);
    });
  }

  int _calculateProgress(List<Task> tasks) {
    int completedTasks = tasks.where((task) => task.isCompleted).length;
    return (completedTasks / tasks.length * 100)
        .round(); // Converts to percentage
  }

  @override
  Widget build(BuildContext context) {
    List<Task> tasksToShow = _showUserTasks ? _userTasks : widget.project.tasks;
    return Scaffold(
        backgroundColor: Color(0xffC5A5FE),
        appBar: AppBar(
          title: Text(widget.project.title,
              style: GoogleFonts.roboto(
                  fontSize: 22, fontWeight: FontWeight.bold)),
          backgroundColor: Color(0xff9155FD),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: _onMenuSelected,
              itemBuilder: (BuildContext context) {
                return {'Edit', 'Delete', 'My Tasks'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            // Call your method to fetch or refresh project details
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailItem(
                  icon: Icons.date_range,
                  title: 'Start Date',
                  subtitle: widget.project.startDate,
                ),
                DetailItem(
                  icon: Icons.date_range,
                  title: 'End Date',
                  subtitle: widget.project.endDate,
                ),
                DetailItem(
                  icon: Icons.trending_up,
                  title: 'Progress',
                  subtitle: '${widget.project.progress}%',
                  progress: widget.project.progress /
                      100, // Pass the progress to the DetailItem widget
                ),
                SizedBox(height: 20),
                Text(
                  'Project Tasks',
                  style: GoogleFonts.roboto(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                ...widget.project.tasks
                    .map((task) => TaskItem(
                          task: task,
                          onTaskCompletionChanged:
                              (Task task, bool isCompleted) {
                            _updateTaskCompletion(task, isCompleted);
                          },
                        ))
                    .toList(),
              ],
            ),
          ),
        ));
  }
}

class DetailItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final double? progress;

  const DetailItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.progress,
  }) : super(key: key);

  @override
  _DetailItemState createState() => _DetailItemState();
}

class _DetailItemState extends State<DetailItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8),
      leading: Icon(widget.icon, color: Colors.white),
      title: Text(widget.title,
          style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500)),
      subtitle: Text(widget.subtitle, style: GoogleFonts.roboto(fontSize: 14)),
      trailing: widget.progress != null
          ? SizedBox(
              width: 100,
              child: LinearProgressIndicator(
                value: widget.progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
              ),
            )
          : null,
    );
  }
}

class TaskItem extends StatefulWidget {
  final Task task;
  final Function(Task task, bool isCompleted) onTaskCompletionChanged;

  const TaskItem({
    Key? key,
    required this.task,
    required this.onTaskCompletionChanged,
  }) : super(key: key);

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.task.isCompleted;
  }

// In your TaskItem stateful widget
  void _toggleCompleted(bool newValue) {
    // This line is no longer needed because we are using the newValue directly
    // widget.task.toggleCompleted();

    setState(() {
      _isCompleted = newValue; // Update the local state with the new value
    });

    widget.onTaskCompletionChanged(
        widget.task, _isCompleted); // Notify the parent widget of the change
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Use InkWell for the ripple effect
      onTap: () => _toggleCompleted(!_isCompleted),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.task.name,
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Due by ${widget.task.dueDate}',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    if (widget.task.isCompleted) ...[
                      SizedBox(height: 4),
                      Chip(
                        label: Text('Completed'),
                        backgroundColor: Color(0xff9155FD),
                      ),
                    ],
                  ],
                ),
              ),
              Switch(
                value: _isCompleted,
                onChanged: _isCompleted
                    ? _toggleCompleted
                    : null, // Disable switch if task is not completed
                activeColor: Colors.white,
                activeTrackColor: Color(0xff9155FD),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
