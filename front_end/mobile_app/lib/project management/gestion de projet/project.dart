import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/project%20management/gestion%20de%20projet/Project.dart';
import 'package:mobile_app/project%20management/gestion%20de%20projet/listeProjet.dart'; // Ensure you have the correct import for Project

class ProjectDetails extends StatefulWidget {
  Project project;

  ProjectDetails({Key? key, required this.project}) : super(key: key);

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  List<Task> _userTasks = [];
  bool _showUserTasks = false;

  get currentUserRole => "admin";
  @override
  void initState() {
    super.initState();
    _filterUserTasks();
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this project?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Dismiss the dialog but do nothing
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Dismiss the dialog and proceed with deletion
                _deleteProject();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteProject() {
    // Logic to delete the project
    // Assuming you have a method to remove the project from your data source, like a list or database

    // Example: Let's say you're just removing from a local list for now
    ListeProjet.projects.remove(widget.project);

    // After deleting, you might want to navigate back or show a success message
    Navigator.of(context).pop(); // Pop current project detail page
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
    if ((currentUserRole == 'admin' ||
            currentUserRole == 'project management') &&
        (value == 'Edit' || value == 'Delete')) {
      switch (value) {
        case 'Edit':
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    EditProjectScreen(project: widget.project)),
          );
          break;
        case 'Delete':
          _showDeleteConfirmation();
          break;
      }
    } else if (value == 'My Tasks') {
      setState(() {
        _showUserTasks = true;
        _filterUserTasks();
      });
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
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                if (currentUserRole == 'admin' ||
                    currentUserRole == 'project management')
                  PopupMenuItem<String>(
                    value: 'Edit',
                    child: Text('Edit'),
                  ),
                if (currentUserRole == 'admin' ||
                    currentUserRole == 'project management')
                  PopupMenuItem<String>(
                    value: 'Delete',
                    child: Text('Delete'),
                  ),
                PopupMenuItem<String>(
                  value: 'My Tasks',
                  child: Text('My Tasks'),
                ),
              ],
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
                ...tasksToShow
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

class EditProjectScreen extends StatefulWidget {
  final Project project;

  EditProjectScreen({Key? key, required this.project}) : super(key: key);

  @override
  _EditProjectScreenState createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.project.title);
    _startDateController =
        TextEditingController(text: widget.project.startDate);
    _endDateController = TextEditingController(text: widget.project.endDate);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  void _saveProject() {
    if (_formKey.currentState!.validate()) {
      widget.project.title = _titleController.text;
      widget.project.startDate = _startDateController.text;
      widget.project.endDate = _endDateController.text;

      Navigator.pop(context, widget.project); // Return the updated project
    }
  }

  void _editTask(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController =
            TextEditingController(text: task.name);
        TextEditingController dueDateController =
            TextEditingController(text: task.dueDate);

        return AlertDialog(
          title: Text('Edit Task'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Task Name'),
                ),
                TextFormField(
                  controller: dueDateController,
                  decoration: InputDecoration(labelText: 'Due Date'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                task.name = nameController.text;
                task.dueDate = dueDateController.text;
                Navigator.of(context).pop();
                setState(() {}); // Refresh the UI with the updated task info
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffC5A5FE),
      appBar: AppBar(
        backgroundColor: Color(0xffC5A5FE),
        title: Text('Edit Project'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveProject,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Project Title'),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Please enter some text';
                return null;
              },
            ),
            TextFormField(
              controller: _startDateController,
              decoration: InputDecoration(labelText: 'Start Date'),
            ),
            TextFormField(
              controller: _endDateController,
              decoration: InputDecoration(labelText: 'End Date'),
            ),
            SizedBox(height: 20),
            Text('Project Tasks', style: Theme.of(context).textTheme.headline6),
            ...widget.project.tasks.map((task) => ListTile(
                  title: Text(task.name),
                  subtitle: Text('Due by ${task.dueDate}'),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _editTask(context, task),
                  ),
                )),
            ElevatedButton(
              onPressed: () => _addNewTask(context),
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewTask(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController dueDateController = TextEditingController();
    TextEditingController _assignedToController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Task Name'),
              ),
              TextFormField(
                controller: dueDateController,
                decoration: InputDecoration(labelText: 'Due Date'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                // Only add the task if fields are not empty
                if (nameController.text.isNotEmpty &&
                    dueDateController.text.isNotEmpty) {
                  Task newTask = Task(
                    name: nameController.text,
                    dueDate: dueDateController.text,
                    isCompleted: false,
                    assignedTo: _assignedToController.text,
                  );
                  setState(() {
                    widget.project.tasks.add(newTask);
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
