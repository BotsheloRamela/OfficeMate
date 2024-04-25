import 'package:flutter/material.dart';
import 'package:office_mate/utils/constants.dart';

class WorkerMoreOptionsDialog extends StatefulWidget {
  final Color highlightColor;
  const WorkerMoreOptionsDialog({
    super.key, 
    required this.highlightColor
  });

  @override
  State<WorkerMoreOptionsDialog> createState() => _WorkerMoreOptionsDialogState();
}

class _WorkerMoreOptionsDialogState extends State<WorkerMoreOptionsDialog> {
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
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {},
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
              onPressed: () {},
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
        ),
      ),
    );
  }
}