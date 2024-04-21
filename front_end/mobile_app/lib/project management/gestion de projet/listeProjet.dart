import 'package:flutter/foundation.dart';

class Project {
  final String title;
  final String startDate;
  final String endDate;
  int _progress;
  final String createdBy;
  final List<Task> tasks;

  Project({
    required this.title,
    required this.startDate,
    required this.endDate,
    int progress = 0, // Default to 0 for initial progress
    required this.createdBy,
    required this.tasks,
  }) : _progress = progress {
    // When initializing the Project, calculate the initial progress
    _calculateProgress();
  }

  // Getter for progress that calculates the percentage of completed tasks
  int get progress {
    return _progress;
  }

  // Method to calculate and update the progress
  void _calculateProgress() {
    if (tasks.isEmpty) {
      _progress = 0;
    } else {
      int completedTasks = tasks.where((task) => task.isCompleted).length;
      _progress = (completedTasks / tasks.length * 100).round();
    }
    // If you use a state management solution, you might want to notify listeners here as well
  }

  // Call this method when a task completion status changes
  void updateTask(Task task) {
    // Find the task and update it, if necessary
    // As you already have the task reference you don't need to find it in the list

    // Then recalculate the progress
    _calculateProgress();

    // If using a state management solution, notify listeners
    // For example, if you're using ChangeNotifier, you would call notifyListeners() here
  }
}

class Task with ChangeNotifier {
  String name;
  String dueDate;
  bool isCompleted;
  String assignedTo;

  Task(
      {required this.name,
      required this.dueDate,
      this.isCompleted = false,
      required this.assignedTo});

  void toggleCompleted() {
    isCompleted = !isCompleted;
    notifyListeners(); // Notify all listening widgets of the change
  }
}

class ListeProjet {
  static final List<Project> projects = [
    Project(
      title: 'Project 1',
      startDate: '15/10/2023',
      endDate: '20/10/2026',
      createdBy: 'John Doe',
      tasks: [
        Task(
          name: 'Design Database Schema',
          dueDate: '30/10/2023',
          isCompleted: true,
          assignedTo: 'oumayma',
        ),
        Task(
          name: 'Implement Authentication',
          dueDate: '15/11/2023',
          isCompleted: false,
          assignedTo: 'haroun',
        ),
        // Add more tasks as needed
      ],
    ),
    Project(
      title: 'Project 2',
      startDate: '20/10/2026',
      endDate: '20/11/2026',
      createdBy: 'Haroun',
      tasks: [
        Task(
          name: 'Initial Project Setup',
          dueDate: '25/10/2026',
          isCompleted: false,
          assignedTo: 'oumayma',
        ),
        Task(
          name: 'Define Project Milestones',
          dueDate: '05/11/2026',
          isCompleted: false,
          assignedTo: 'oumayma',
        ),
        // Add more tasks as needed
      ],
    ),
    // ... Add more project instances with tasks as needed
  ];
}
