import 'package:flutter/material.dart';
import 'package:office_mate/data/models/office.dart';
import 'package:office_mate/ui/screens/office_manager_screen.dart';
import 'package:office_mate/ui/viewmodels/office_details_viewmodel.dart';
import 'package:office_mate/ui/widgets/custom_search_bar.dart';
import 'package:office_mate/ui/widgets/office_card.dart';
import 'package:office_mate/ui/widgets/worker_dialog.dart';
import 'package:office_mate/ui/widgets/worker_more_options_dialog.dart';
import 'package:office_mate/utils/avatar_icons.dart';
import 'package:office_mate/utils/constants.dart';
import 'package:office_mate/utils/office_colors.dart';
import 'package:provider/provider.dart';

class OfficeDetailsScreen extends StatefulWidget {
  final Office office;
  final int workerCount;
  const OfficeDetailsScreen({
    super.key, 
    required this.office,
    required this.workerCount
  });

  @override
  State<OfficeDetailsScreen> createState() => _OfficeDetailsScreenState();
}

class _OfficeDetailsScreenState extends State<OfficeDetailsScreen> {

  final _searchBarController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    Color highlightColor = Color(int.parse(OfficeColors.getColors()[
      widget.office.officeColorId- 1
    ]));

    // State variable to track if the user is editing a worker
    bool isEditing = false;

    /// Save the worker to the database
    void saveWorker(int avatarId, String? workerId) {
      if (!isEditing) {
        context.read<OfficeDetailsViewModel>().createWorker(
          firstNameController.text,
          lastNameController.text,
          widget.office.officeId, 
          avatarId
        );
      } else {
        context.read<OfficeDetailsViewModel>().updateWorker(
          firstNameController.text,
          lastNameController.text,
          widget.office.officeId, 
          avatarId,
          workerId!
        );
        setState(() {
          isEditing = false;
        });
      }
    }

    /// Show the worker dialog
    void showWorkerDialog(
      String? firstName,
      String? lastName,
      int? avatarId,
      String? workerId
    ) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return WorkerDialog(
            firstNameController: firstNameController..text = firstName ?? '',
            lastNameController: lastNameController..text = lastName ?? '',
            highlightColor: highlightColor,
            saveWorker: (int _) => saveWorker(_, workerId),
            isEditing: isEditing,
            avatarId: avatarId,
            workerId: workerId
          );
        },
      );
    }

    /// Open the edit dialog
    void openEditDialog(
      BuildContext context,
      String firstName,
      String lastName,
      int avatarId,
      String workerId
    ) {
      setState(() {
        isEditing = true;
      });

      Navigator.pop(context); // Close the more options dialog

      showWorkerDialog(
        firstName,
        lastName,
        avatarId,
        workerId
      );
    }

    /// Show the more options dialog
    void showMoreOptionsDialog(
      String firstName, 
      String lastName, 
      String workerId, 
      int avatarId
    ) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return WorkerMoreOptionsDialog(
            highlightColor: highlightColor,
            firstName: firstName,
            lastName: lastName,
            workerId: workerId,
            avatarId: avatarId,
            displayEditDialog: (int editedAvatarId) => openEditDialog(
                context, 
                firstName, 
                lastName,
                editedAvatarId,
                workerId,
              ),
            deleteWorker: () {
              context.read<OfficeDetailsViewModel>().deleteWorker(
                widget.office.officeId,
                workerId
              );
            }
          );
        },
      );
    }
    
    // Update the list view based on the search query
    void updateListView(String searchQuery) {
      final filteredWorkers = context.read<OfficeDetailsViewModel>().searchWorkers(
        widget.office.officeId,
        searchQuery
      );

      context.read<OfficeDetailsViewModel>().updateWorkers(filteredWorkers);
    }

    // Listen for changes in the search bar
    _searchBarController.addListener(() {
      updateListView(_searchBarController.text);
    });

    // Fetch the workers for the office when the screen loads
    context.read<OfficeDetailsViewModel>().fetchWorkers(widget.office.officeId);

    return SafeArea(
      child: Consumer<OfficeDetailsViewModel>(
        builder: (context, officeDetailsViewModel, child) => Scaffold(
          backgroundColor: AppColors.backgroundColor,
          floatingActionButton: FloatingActionButton(
            onPressed: () => showWorkerDialog(null, null, null, null),
            backgroundColor: highlightColor,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          appBar: AppBar(
            title: const Text(
              'Office',
              style: TextStyle(
                color: AppColors.secondaryColor,
                fontSize: AppConstants.mdFontSize,
                fontWeight: FontWeight.bold
              ),
            ),
            centerTitle: true,
            backgroundColor: AppColors.backgroundColor,
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.horizontalAppPadding),
              child: Column(
                children: [
                  OfficeCard(
                    companyName: widget.office.name,
                    occupantsCount: officeDetailsViewModel.getWorkers().length,
                    officeCapacity: widget.office.officeCapacity,
                    location: widget.office.location,
                    officeColorId: widget.office.officeColorId,
                    email: widget.office.email,
                    phone: widget.office.phone,
                    onEdit: () {
                      // Navigate to the office manager screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OfficeManagerScreen(
                            office: widget.office,
                            isEditing: true,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30.0),
                  CustomSearchBar(
                    controller: _searchBarController,
                    borderColor: highlightColor,
                  ),
                  const SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Staff Members In Office',
                        style: TextStyle(
                          fontSize: AppConstants.xlFontSize,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      Text(
                        '${officeDetailsViewModel.getWorkers().length}',
                        style: const TextStyle(
                          fontSize: AppConstants.mdFontSize,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: officeDetailsViewModel.getWorkers().map((worker) {
                      return ListTile(
                        contentPadding: const EdgeInsets.only(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 10
                        ),
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(AvatarIcons.getAllAvatars()[worker.avatarId]),
                        ),
                        title: Text(
                          '${worker.name} ${worker.familyName}',
                          style: const TextStyle(
                            fontSize: AppConstants.mdFontSize,
                            color: AppColors.secondaryColor,
                          )
                        ),
                        trailing: GestureDetector(
                          onTap: () => showMoreOptionsDialog(
                            worker.name, 
                            worker.familyName, 
                            worker.workerId, 
                            worker.avatarId
                          ),
                          child: const Icon(
                            Icons.more_vert,
                            color: AppColors.secondaryColor,
                          )
                        )
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}