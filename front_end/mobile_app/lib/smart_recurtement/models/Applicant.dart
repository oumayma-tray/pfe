class Applicant {
  String name;
  String email;
  String phone;
  String coverLetter;
  String cv;

  Applicant({
    required this.name,
    required this.email,
    required this.phone,
    required this.coverLetter,
    required this.cv,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'coverLetter': coverLetter,
      'cv': cv,
    };
  }

  factory Applicant.fromMap(Map<String, dynamic> map) {
    return Applicant(
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      coverLetter: map['coverLetter'],
      cv: map['cv'],
    );
  }
}
