import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/services/job_Service/RecruitmentServicedart';

import 'package:mobile_app/smart_recurtement/models/company.dart';

class AddCompanyPage extends StatefulWidget {
  @override
  _AddCompanyPageState createState() => _AddCompanyPageState();
}

class _AddCompanyPageState extends State<AddCompanyPage> {
  final _formKey = GlobalKey<FormState>();
  final RecruitmentService _recruitmentService = RecruitmentService();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _criteriaController = TextEditingController();
  final TextEditingController _jobOpportunityController = TextEditingController();
  final TextEditingController _aboutCompanyController = TextEditingController();
  final TextEditingController _jobResponsibilitiesController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        Company newCompany = Company(
          companyName: _companyNameController.text,
          job: _jobTitleController.text,
          city: _cityController.text,
          sallary: _salaryController.text,
          image: _imageController.text,
          mainCriteria: _criteriaController.text,
          jobOpportunity: _jobOpportunityController.text,
          aboutCompany: _aboutCompanyController.text,
          jobResponsbilities: _jobResponsibilitiesController.text.split(','),
          tag: _tagController.text.split(','),
          applicants: [],
        );
        await _recruitmentService.addCompany(newCompany);
        Navigator.pop(context, true);
      } catch (e) {
        print('Error adding company: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Company'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _companyNameController,
                decoration: InputDecoration(labelText: 'Company Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a company name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _jobTitleController,
                decoration: InputDecoration(labelText: 'Job Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a job title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a city';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _salaryController,
                decoration: InputDecoration(labelText: 'Salary'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a salary';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageController,
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _criteriaController,
                decoration: InputDecoration(labelText: 'Criteria'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter criteria';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _jobOpportunityController,
                decoration: InputDecoration(labelText: 'Job Opportunity'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter job opportunity';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _aboutCompanyController,
                decoration: InputDecoration(labelText: 'About Company'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter information about the company';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _jobResponsibilitiesController,
                decoration: InputDecoration(labelText: 'Job Responsibilities (comma separated)'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter job responsibilities';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tagController,
                decoration: InputDecoration(labelText: 'Tags (comma separated)'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter tags';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Company'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
