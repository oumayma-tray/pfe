// Employees.dart
class Employee {
  final String name;
  String? role;
  final String email;
  final String firstName;
  final String lastName;
  final String jobTitle;
  final String language;
  final String phoneNumber;
  final String country;
  final String imagePath; // Add this line for the image path or URL

  Employee({
    this.role,
    required this.firstName,
    required this.lastName,
    required this.language,
    required this.name,
    required this.email,
    required this.jobTitle,
    required this.phoneNumber,
    required this.country,
    required this.imagePath, // Include the imagePath in the constructor
  });
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Employee && other.name == name && other.email == email;
  }

  @override
  int get hashCode => name.hashCode ^ email.hashCode;
}

Future<Employee> getCurrentUser() async {
  return getMockEmployees().first;
}

// Example of a list of employees which you might fetch from a database or API
List<Employee> getMockEmployees() {
  return [
    Employee(
      name: 'Jane Doe',
      email: 'jane.doe@example.com',
      jobTitle: 'Developer',
      phoneNumber: '555-0100',
      country: 'USA',
      imagePath: 'assets/Ellipse 10.png',
      firstName: 'Jane',
      lastName: 'Doe',
      language: 'English',
    ),
    Employee(
      name: 'John Smith',
      firstName: 'Jane',
      lastName: 'Smith',
      language: 'English',
      email: 'john.smith@example.com',
      jobTitle: 'Project Manager',
      phoneNumber: '555-0101',
      country: 'USA',
      imagePath: 'assets/Ellipse 11.png',
    ),
    Employee(
      name: 'oumayma',
      firstName: 'oumayma',
      lastName: 'tray',
      language: 'English',
      email: 'john.smith@example.com',
      jobTitle: 'Project Manager',
      phoneNumber: '555-0101',
      country: 'USA',
      imagePath: 'assets/Ellipse 11.png',
    ),
    Employee(
      name: 'haroun',
      firstName: 'haroun',
      lastName: 'tray',
      language: 'English',
      email: 'john.smith@example.com',
      jobTitle: 'Project Manager',
      phoneNumber: '555-0101',
      country: 'USA',
      imagePath: 'assets/Ellipse 15.png',
    ),
    Employee(
      name: 'majdi',
      firstName: 'majdi',
      lastName: 'tray',
      language: 'English',
      email: 'john.smith@example.com',
      jobTitle: 'Project Manager',
      phoneNumber: '555-0101',
      country: 'USA',
      imagePath: 'assets/Ellipse 14.png',
    ),
    // Add more employees as needed
  ];
}
