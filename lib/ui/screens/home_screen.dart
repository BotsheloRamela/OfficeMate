import 'package:flutter/material.dart';
import 'package:office_mate/ui/widgets/office_card.dart';
import 'package:office_mate/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: null, // TODO: Implement onPressed
          backgroundColor: AppColors.primaryColor,
          child: Icon(Icons.add, color: Colors.white),
        ),
        body: Padding(
          padding: EdgeInsets.all(AppConstants.horizontalAppPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 40.0),
              Text(
                'All Offices',
                style: TextStyle(
                  fontSize: AppConstants.xlFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20.0),
              OfficeCard(
                companyName: 'Google',
                occupantsCount: 5,
                officeCapacity: 10,
                location: 'Mountain View, CA',
                officeColor: '0xFFFE9B70',
                email: 'info@google.com',
                phone: '1-800-123-4567',
              )
            ],
          ),
        ),
      )
    );
  }
}