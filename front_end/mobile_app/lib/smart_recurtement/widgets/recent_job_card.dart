import 'package:flutter/material.dart';
import 'package:mobile_app/smart_recurtement/constants.dart';
import 'package:mobile_app/smart_recurtement/models/company.dart';

class RecentJobCard extends StatelessWidget {
  final Company company;

  RecentJobCard({required this.company});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      elevation: 0.0,
      margin: EdgeInsets.only(
        right: screenWidth * 0.01,
        top: screenHeight * 0.02,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: Container(
          width: screenWidth * 0.13,
          height: screenWidth * 0.13,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            image: DecorationImage(
              image: AssetImage(company.image ?? 'assets/placeholder.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(company.job ?? 'Job Title', style: kTitleStyle),
        subtitle: Text(
          "${company.companyName ?? 'Company Name'} • ${company.mainCriteria ?? 'Criteria'}",
        ),
        trailing: Icon(
          Icons.more_vert,
          color: kTextColor,
        ),
      ),
    );
  }
}
