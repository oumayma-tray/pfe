import 'package:flutter/foundation.dart';

class Project {
  final String title;
  final String startDate;
  final String endDate;
  final int progress;
  final String createdBy;
  final List<Task> tasks;

  Project({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.progress,
    required this.createdBy,
    required this.tasks,
  });
}

class Task with ChangeNotifier {
  String name;
  String dueDate;
  bool isCompleted;

  Task({
    required this.name,
    required this.dueDate,
    this.isCompleted = false,
  });

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
      progress: 54,
      createdBy: 'John Doe',
      tasks: [
        Task(
          name: 'Design Database Schema',
          dueDate: '30/10/2023',
          isCompleted: true,
        ),
        Task(
          name: 'Implement Authentication',
          dueDate: '15/11/2023',
          isCompleted: false,
        ),
        // Add more tasks as needed
      ],
    ),
    Project(
      title: 'Project 2',
      startDate: '20/10/2026',
      endDate: '20/11/2026',
      progress: 27,
      createdBy: 'Haroun',
      tasks: [
        Task(
          name: 'Initial Project Setup',
          dueDate: '25/10/2026',
          isCompleted: false,
        ),
        Task(
          name: 'Define Project Milestones',
          dueDate: '05/11/2026',
          isCompleted: false,
        ),
        // Add more tasks as needed
      ],
    ),
    // ... Add more project instances with tasks as needed
  ];
}
