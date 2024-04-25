import 'package:flutter/material.dart';
import 'package:office_mate/data/models/office.dart';
import 'package:office_mate/ui/widgets/custom_search_bar.dart';
import 'package:office_mate/ui/widgets/office_card.dart';
import 'package:office_mate/utils/avatar_icons.dart';
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
              const SizedBox(height: 30.0),
              CustomSearchBar(
                controller: _searchBarController,
                borderColor: widget.office.officeColor,
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
                    '${widget.office.occupantsCount}',
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
                    contentPadding: EdgeInsets.zero,
                    leading: ClipOval(
                      child: Image.asset(
                        AvatarIcons.getAvatarById(worker.avatarId),
                        width: AppConstants.avatarSize,
                        height: AppConstants.avatarSize,
                      ),
                    ),
                    title: Text(
                      '${worker.name} ${worker.familyName}',
                      style: const TextStyle(
                        fontSize: AppConstants.mdFontSize,
                        color: AppColors.secondaryColor,
                      )
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {} // TODO: Implement onPressed
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