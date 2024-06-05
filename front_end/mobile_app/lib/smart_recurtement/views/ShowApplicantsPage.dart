import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobile_app/services/job_Service/RecruitmentService.dart';
import 'package:mobile_app/smart_recurtement/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart'; // For platform-specific method channels

class ShowApplicantsPage extends StatelessWidget {
  static const platform = MethodChannel('com.mobile_app.flutter/python');

  Future<File> _downloadFile(String url, String filename) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final File file = File('${dir.path}/$filename');

    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      final downloadTask = ref.writeToFile(file);
      await downloadTask;
      return file;
    } catch (e) {
      throw Exception('Error downloading file: $e');
    }
  }

  Future<int> _calculateScore(File file, List<String> requiredSkills) async {
    try {
      final String absolutePath = file.path;
      final int score = await platform.invokeMethod('calculateScore',
          {'filePath': absolutePath, 'skills': requiredSkills});
      print("Calculated Score: $score");
      return score;
    } on PlatformException catch (e) {
      print("Failed to calculate score: '${e.message}'.");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Applicants', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('companies').snapshots(),
        builder: (context, companySnapshot) {
          if (!companySnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final companies = companySnapshot.data!.docs;

          return ListView.builder(
            itemCount: companies.length,
            itemBuilder: (context, index) {
              var company = companies[index];
              var companyData = company.data() as Map<String, dynamic>;
              var applicants = companyData.containsKey('applicants')
                  ? companyData['applicants'] as List<dynamic>
                  : [];
              var requiredSkills = companyData.containsKey('requiredSkills')
                  ? List<String>.from(companyData['requiredSkills'])
                  : <String>[];

              return Card(
                margin: EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 3,
                child: ExpansionTile(
                  title: Text(
                    companyData['companyName'] ?? 'No Company Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  children: applicants.isNotEmpty
                      ? applicants.map((applicantData) {
                          var applicant = applicantData as Map<String, dynamic>;
                          return FutureBuilder<File>(
                            future: _downloadFile(
                                applicant['cv'], '${applicant['name']}.pdf'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  var file = snapshot.data!;
                                  return FutureBuilder<int>(
                                    future:
                                        _calculateScore(file, requiredSkills),
                                    builder: (context, scoreSnapshot) {
                                      if (scoreSnapshot.connectionState ==
                                          ConnectionState.done) {
                                        if (scoreSnapshot.hasData) {
                                          var score = scoreSnapshot.data!;
                                          return ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor:
                                                  Colors.deepPurpleAccent,
                                              child: Text(
                                                applicant['name']
                                                        ?.substring(0, 1) ??
                                                    '',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            title: Text(
                                                applicant['name'] ?? 'No Name'),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Email: ${applicant['email'] ?? 'No Email'}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                Text(
                                                  'Phone: ${applicant['phone'] ?? 'No Phone'}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                Text(
                                                  'Cover Letter: ${applicant['coverLetter'] ?? 'No Cover Letter'}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (await canLaunch(
                                                        file.path)) {
                                                      await launch(file.path);
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                            content: Text(
                                                                'Could not launch ${file.path}')),
                                                      );
                                                    }
                                                  },
                                                  child: Text(
                                                    'CV: ${applicant['cv'] ?? 'No CV'}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.blue,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'Skill Match Score: $score',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            isThreeLine: true,
                                          );
                                        } else {
                                          return ListTile(
                                            title:
                                                Text('Error calculating score'),
                                          );
                                        }
                                      } else {
                                        return ListTile(
                                          title: Text('Calculating score...'),
                                          subtitle: LinearProgressIndicator(),
                                        );
                                      }
                                    },
                                  );
                                } else {
                                  return ListTile(
                                    title: Text('Error downloading CV'),
                                  );
                                }
                              } else {
                                return ListTile(
                                  title: Text('Downloading CV...'),
                                  subtitle: LinearProgressIndicator(),
                                );
                              }
                            },
                          );
                        }).toList()
                      : [ListTile(title: Text('No applicants'))],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
