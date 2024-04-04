// Employees.dart
class Employee {
  final String name;
  final String email;
  final String firstName;
  final String lastName;
  final String jobTitle;
  final String language;
  final String phoneNumber;
  final String country;
  final String imagePath; // Add this line for the image path or URL

  Employee({
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

  // ...rest of your code
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
      imagePath: 'assets/employee.png',
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
      imagePath: 'assets/employee.png',
    ),
    // Add more employees as needed
  ];
}
