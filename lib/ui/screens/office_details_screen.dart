import 'package:flutter/material.dart';
import 'package:office_mate/data/models/office.dart';
import 'package:office_mate/ui/widgets/custom_search_bar.dart';
import 'package:office_mate/ui/widgets/office_card.dart';
import 'package:office_mate/utils/constants.dart';

class OfficeDetailsScreen extends StatefulWidget {
  final Office office;
  const OfficeDetailsScreen({super.key, required this.office});

  @override
  State<OfficeDetailsScreen> createState() => _OfficeDetailsScreenState();
}

class _OfficeDetailsScreenState extends State<OfficeDetailsScreen> {

  final _searchBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        floatingActionButton: const FloatingActionButton(
          onPressed: null, // TODO: Implement onPressed
          backgroundColor: AppColors.primaryColor,
          child: Icon(Icons.add, color: Colors.white),
        ),
        appBar: AppBar(
          title: const Text('Office'),
          centerTitle: true,
          backgroundColor: AppColors.backgroundColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppConstants.horizontalAppPadding),
          child: Column(
            children: [
              OfficeCard(
                companyName: widget.office.name,
                occupantsCount: widget.office.occupantsCount,
                officeCapacity: widget.office.officeCapacity,
                location: widget.office.location,
                officeColor: widget.office.officeColor,
                email: widget.office.email,
                phone: widget.office.phone,
              ),
              const SizedBox(height: 20.0),
              CustomSearchBar(controller: _searchBarController)
            ],
          ),
        ),
      ),
    );
  }
}