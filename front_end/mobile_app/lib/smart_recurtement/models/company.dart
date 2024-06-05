import 'package:mobile_app/smart_recurtement/models/applicant.dart';

class Company {
  final String? companyId;
  final String? companyName;
  final String? job;
  final String? city;
  final String? salary;
  final String? image;
  final String? mainCriteria;
  final String? jobOpportunity;
  final String? aboutCompany;
  final List<String>? jobResponsibilities;
  final List<String>? tag;
  final List<Applicant>? applicants;
  final List<String>? requiredSkills; // Add this field

  Company({
    this.companyId,
    this.city,
    this.job,
    this.companyName,
    this.salary,
    this.tag,
    this.image,
    this.mainCriteria,
    this.jobOpportunity,
    this.jobResponsibilities,
    this.aboutCompany,
    this.applicants,
    this.requiredSkills, // Initialize in the constructor
  });

  factory Company.fromMap(Map<String, dynamic> map, String id) {
    return Company(
      companyId: id,
      companyName: map['companyName'] as String? ?? '',
      job: map['job'] as String? ?? '',
      city: map['city'] as String? ?? '',
      salary: map['salary'] as String? ?? '',
      image: map['image'] as String? ?? '',
      mainCriteria: map['mainCriteria'] as String? ?? '',
      jobOpportunity: map['jobOpportunity'] as String? ?? '',
      aboutCompany: map['aboutCompany'] as String? ?? '',
      jobResponsibilities: List<String>.from(map['jobResponsibilities'] ?? []),
      tag: List<String>.from(map['tag'] ?? []),
      applicants: (map['applicants'] as List<dynamic>?)
          ?.map((e) => Applicant.fromMap(e as Map<String, dynamic>))
          .toList(),
      requiredSkills: List<String>.from(
          map['requiredSkills'] ?? []), // Parse requiredSkills
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyName': companyName,
      'job': job,
      'city': city,
      'salary': salary,
      'image': image,
      'mainCriteria': mainCriteria,
      'jobOpportunity': jobOpportunity,
      'aboutCompany': aboutCompany,
      'jobResponsibilities': jobResponsibilities,
      'tag': tag,
      'applicants': applicants?.map((e) => e.toMap()).toList(),
      'requiredSkills': requiredSkills, // Include in the map
    };
  }
}
