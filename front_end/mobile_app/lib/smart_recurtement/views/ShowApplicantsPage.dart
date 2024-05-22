import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowApplicantsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Applicants'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('applicants').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final applicants = snapshot.data!.docs;
          return ListView.builder(
            itemCount: applicants.length,
            itemBuilder: (context, index) {
              var applicant = applicants[index];
              return ListTile(
                title: Text(applicant['name'] ?? 'No Name'),
                subtitle: Text(applicant['email'] ?? 'No Email'),
              );
            },
          );
        },
      ),
    );
  }
}
