import 'package:flutter/material.dart';
import 'package:office_mate/utils/constants.dart';

class WorkerMoreOptionsDialog extends StatefulWidget {
  final Color highlightColor;
  final String firstName;
  final String lastName;
  final String workerId;
  final String avatarId;
  final Function(String) displayEditDialog;

  const WorkerMoreOptionsDialog({
    super.key, 
    required this.highlightColor,
    required this.firstName,
    required this.lastName,
    required this.workerId,
    required this.avatarId,
    required this.displayEditDialog
  });

  @override
  State<WorkerMoreOptionsDialog> createState() => _WorkerMoreOptionsDialogState();
}

class _WorkerMoreOptionsDialogState extends State<WorkerMoreOptionsDialog> {

  bool _displayDeleteDialog = false;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          color: AppColors.backgroundColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_displayDeleteDialog) _defaultDialogContent(),
            if (_displayDeleteDialog) _deleteMemberDialog(),
          ],
        ),
      ),
    );
  }

  Widget _defaultDialogContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () => widget.displayEditDialog(widget.avatarId),
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(widget.highlightColor),
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 50, vertical: 12)
              )
            ),
          child: const Text(
            'EDIT STAFF MEMBER',
            style: TextStyle(color: Colors.white, fontSize: AppConstants.xsFontSize)
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => setState(() {
            _displayDeleteDialog = true;
          }),
          child: const Text(
            'DELETE STAFF MEMBER',
            style: TextStyle(
              color: Colors.red, 
              fontSize: AppConstants.xsFontSize,
              fontWeight: FontWeight.bold
            )
          ),
        )
      ],
    );
  }

  Widget _deleteMemberDialog() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Are you sure you want to delete this staff member?',
          style: TextStyle(
            color: AppColors.secondaryColor,
            fontSize: AppConstants.mdFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(widget.highlightColor),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
                )
              ),
              child: const Text(
                'YES',
                style: TextStyle(color: Colors.white, fontSize: AppConstants.xsFontSize)
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _displayDeleteDialog = false;
                });
              },
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Colors.grey),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
                )
              ),
              child: const Text(
                'NO',
                style: TextStyle(color: Colors.white, fontSize: AppConstants.xsFontSize)
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () {
            setState(() {
              _displayDeleteDialog = false;
            });
          },
          child: const Text(
            'Go Back',
            style: TextStyle(
              color: AppColors.secondaryColor, 
              fontSize: AppConstants.xsFontSize,
              fontWeight: FontWeight.bold
            )
          ),
        )
      ],
    );
  }

}