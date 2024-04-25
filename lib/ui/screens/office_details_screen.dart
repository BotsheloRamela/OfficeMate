import 'package:flutter/material.dart';
import 'package:office_mate/data/models/office.dart';
import 'package:office_mate/ui/viewmodels/office_details_viewmodel.dart';
import 'package:office_mate/ui/widgets/create_worker_dialog.dart';
import 'package:office_mate/ui/widgets/custom_search_bar.dart';
import 'package:office_mate/ui/widgets/office_card.dart';
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

    OfficeDetailsViewModel viewModel = OfficeDetailsViewModel();

    void createWorker(String avatarId ) {
      viewModel.createWorker(
        firstNameController.text,
        lastNameController.text,
        widget.office.officeId, 
        avatarId
      );
    }

    void showCreateWorkerDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CreateWorkerDialog(
            firstNameController: firstNameController,
            lastNameController: lastNameController,
            highlightColor: highlightColor,
            createWorker: createWorker,
          );
        },
      );
    }

    void showMoreOptionsDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return WorkerMoreOptionsDialog(highlightColor: highlightColor);
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        floatingActionButton: FloatingActionButton(
          onPressed: showCreateWorkerDialog,
          backgroundColor: highlightColor,
          child: const Icon(Icons.add, color: Colors.white),
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
                      onTap: showMoreOptionsDialog,
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