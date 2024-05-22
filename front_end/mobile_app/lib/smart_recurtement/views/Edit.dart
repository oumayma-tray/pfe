import 'package:flutter/material.dart';
import 'package:mobile_app/services/job_Service/RecruitmentService.dart';
import 'package:mobile_app/smart_recurtement/models/company.dart';

class EditCompanyPage extends StatefulWidget {
  final String companyId;
  final Company company;

  EditCompanyPage({required this.companyId, required this.company});

  @override
  _EditCompanyPageState createState() => _EditCompanyPageState();
}

class _EditCompanyPageState extends State<EditCompanyPage> {
  final _formKey = GlobalKey<FormState>();
  final RecruitmentService _recruitmentService = RecruitmentService();
  late TextEditingController _companyNameController;
  late TextEditingController _jobTitleController;
  late TextEditingController _cityController;
  late TextEditingController _salaryController;
  late TextEditingController _imageController;
  late TextEditingController _criteriaController;
  late TextEditingController _jobOpportunityController;
  late TextEditingController _aboutCompanyController;
  late TextEditingController _jobResponsibilitiesController;
  late TextEditingController _tagController;

  @override
  void initState() {
    super.initState();
    _companyNameController =
        TextEditingController(text: widget.company.companyName);
    _jobTitleController = TextEditingController(text: widget.company.job);
    _cityController = TextEditingController(text: widget.company.city);
    _salaryController = TextEditingController(text: widget.company.sallary);
    _imageController = TextEditingController(text: widget.company.image);
    _criteriaController =
        TextEditingController(text: widget.company.mainCriteria);
    _jobOpportunityController =
        TextEditingController(text: widget.company.jobOpportunity);
    _aboutCompanyController =
        TextEditingController(text: widget.company.aboutCompany);
    _jobResponsibilitiesController = TextEditingController(
        text: widget.company.jobResponsbilities?.join(',') ?? '');
    _tagController =
        TextEditingController(text: widget.company.tag?.join(',') ?? '');
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _jobTitleController.dispose();
    _cityController.dispose();
    _salaryController.dispose();
    _imageController.dispose();
    _criteriaController.dispose();
    _jobOpportunityController.dispose();
    _aboutCompanyController.dispose();
    _jobResponsibilitiesController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Company updatedCompany = Company(
        companyId: widget.companyId,
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
        applicants: widget.company.applicants,
      );

      try {
        await _recruitmentService.updateCompany(
            widget.companyId, updatedCompany);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Company updated successfully!')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update company: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Company'),
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
                decoration: InputDecoration(
                    labelText: 'Job Responsibilities (comma separated)'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter job responsibilities';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tagController,
                decoration:
                    InputDecoration(labelText: 'Tags (comma separated)'),
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
                child: Text('Update Company'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
