import 'package:flutter/material.dart';
import 'package:office_mate/ui/screens/office_details_screen.dart';
import 'package:office_mate/ui/viewmodels/home_screen_viewmodel.dart';
import 'package:office_mate/ui/widgets/office_card.dart';
import 'package:office_mate/utils/constants.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    // Initialize and fetch offices when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeScreenViewModel>(context, listen: false).fetchOffices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: const FloatingActionButton(
          onPressed: null, // TODO: Implement onPressed
          backgroundColor: AppColors.primaryColor,
          child: Icon(Icons.add, color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppConstants.horizontalAppPadding),
          child: Consumer<HomeScreenViewModel>(
            builder: (context, viewModel, _) {
              return viewModel.isLoading
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
                          itemBuilder: (context, index) {
                            final office = viewModel.offices[index];
                            return GestureDetector(
                              onTap: () {
                                // Navigate to the office details screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OfficeDetailsScreen(office: office,),
                                  ),
                                );
                              },
                              child: OfficeCard(
                                companyName: office.name,
                                occupantsCount: office.occupantsCount,
                                officeCapacity: office.officeCapacity,
                                location: office.location,
                                officeColor: office.officeColor,
                                email: office.email,
                                phone: office.phone,
                              ),
                            );
                          },
                        )
                      )
                    ],
                  );
            },
          ),
        ),
      )
    );
  }
}