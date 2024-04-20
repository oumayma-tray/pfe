import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/project%20management/gestion%20de%20projet/Project.dart';
import 'package:mobile_app/project%20management/gestion%20de%20projet/listeProjet.dart'; // Ensure you have the correct import for Project

class ProjectDetails extends StatelessWidget {
  final Project project;

  ProjectDetails({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.title,
            style:
                GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor:
            Colors.indigo, // Prefer a color that matches your branding
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailItem(
              icon: Icons.date_range,
              title: 'Start Date',
              subtitle: project.startDate,
            ),
            DetailItem(
              icon: Icons.date_range,
              title: 'End Date',
              subtitle: project.endDate,
            ),
            DetailItem(
              icon: Icons.trending_up,
              title: 'Progress',
              subtitle: '${project.progress}%',
            ),
            SizedBox(height: 20),
            Text(
              'Project Tasks',
              style:
                  GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            ...project.tasks.map((task) => TaskItem(task: task)).toList(),
          ],
        ),
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const DetailItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8),
      leading: Icon(icon, color: Colors.indigo),
      title: Text(title,
          style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: GoogleFonts.roboto(fontSize: 14)),
    );
  }
}

class TaskItem extends StatelessWidget {
  final Task task; // Your task model

  const TaskItem({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(task.name, style: GoogleFonts.roboto()),
        subtitle: Text('Due by ${task.dueDate}', style: GoogleFonts.roboto()),
        trailing: Checkbox(
          value: task.isCompleted,
          onChanged: (newValue) {
            // Handle task completion toggle
          },
        ),
      ),
    );
  }
}
