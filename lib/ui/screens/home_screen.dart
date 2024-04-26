import 'package:flutter/material.dart';
import 'package:office_mate/ui/screens/office_manager_screen.dart';
import 'package:office_mate/ui/screens/office_details_screen.dart';
import 'package:office_mate/ui/viewmodels/office_manager_viewmodel.dart';
import 'package:office_mate/ui/widgets/office_card.dart';
import 'package:office_mate/utils/constants.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int officeWorkerCount = 0;

  @override
  Widget build(BuildContext context) {

    context.read<OfficeManagerViewModel>().fetchOffices();

    return Consumer<OfficeManagerViewModel>(
      builder: (context, viewModel, child) => SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OfficeManagerScreen(),
                ),
              );
            },
            backgroundColor: AppColors.primaryColor,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.all(AppConstants.horizontalAppPadding),
            child: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 40.0),
                    const Text(
                      'All Offices',
                      style: TextStyle(
                        fontSize: AppConstants.xlFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Expanded(
                      child: ListView.builder(
                        itemCount: viewModel.offices.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final office = viewModel.offices[index];
                          final officeWorkerCount = viewModel.officeWorkerCount[office.officeId] as int;
                          return GestureDetector(
                            onTap: () {
                              // Navigate to the office details screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OfficeDetailsScreen(
                                    office: office, 
                                    workerCount: officeWorkerCount
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: OfficeCard(
                                companyName: office.name,
                                occupantsCount: officeWorkerCount,
                                officeCapacity: office.officeCapacity,
                                location: office.location,
                                officeColorId: office.officeColorId,
                                email: office.email,
                                phone: office.phone,
                                onEdit: () {
                                  // Navigate to the office manager screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OfficeManagerScreen(
                                        office: office,
                                        isEditing: true,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      )
                    )
                  ],
                ),
          ),
        )
      ),
    );
  }
}