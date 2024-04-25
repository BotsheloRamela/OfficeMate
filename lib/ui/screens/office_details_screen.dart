import 'package:flutter/material.dart';
import 'package:office_mate/data/models/office.dart';
import 'package:office_mate/ui/viewmodels/office_details_viewmodel.dart';
import 'package:office_mate/ui/widgets/custom_search_bar.dart';
import 'package:office_mate/ui/widgets/office_card.dart';
import 'package:office_mate/ui/widgets/worker_dialog.dart';
import 'package:office_mate/ui/widgets/worker_more_options_dialog.dart';
import 'package:office_mate/utils/avatar_icons.dart';
import 'package:office_mate/utils/constants.dart';

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

    Color highlightColor = Color(int.parse(widget.office.officeColor));

    bool isEditing = false;

    OfficeDetailsViewModel viewModel = OfficeDetailsViewModel();

    /// Save the worker to the database
    void saveWorker(String avatarId, String? workerId) {
      if (!isEditing) {
        viewModel.createWorker(
          firstNameController.text,
          lastNameController.text,
          widget.office.officeId, 
          avatarId
        );
      } else {
        viewModel.updateWorker(
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
      String? avatarId,
      String? workerId
    ) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return WorkerDialog(
            firstNameController: firstNameController..text = firstName ?? '',
            lastNameController: lastNameController..text = lastName ?? '',
            highlightColor: highlightColor,
            saveWorker: (_) => saveWorker(_, workerId),
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
      String avatarId,
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
      String avatarId
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
            displayEditDialog: (
              String editedAvatarId
            ) => openEditDialog(
              context, 
              firstName, 
              lastName,
              editedAvatarId,
              workerId
            )
          );
        },
      );
    }

    return SafeArea(
      child: Scaffold(
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
          // TODO: Add delete office icon button and functionality
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppConstants.horizontalAppPadding),
          child: Column(
            children: [
              OfficeCard(
                companyName: widget.office.name,
                occupantsCount: widget.workerCount,
                officeCapacity: widget.office.officeCapacity,
                location: widget.office.location,
                officeColor: widget.office.officeColor,
                email: widget.office.email,
                phone: widget.office.phone,
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
                    '${widget.workerCount}',
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
                children: widget.office.workers.map((worker) {
                  return ListTile(
                    contentPadding: const EdgeInsets.only(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 10
                    ),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(AvatarIcons.getAvatarById(worker.avatarId)),
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
    );
  }
}