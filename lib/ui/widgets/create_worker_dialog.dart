
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:office_mate/ui/widgets/default_textfield.dart';
import 'package:office_mate/utils/constants.dart';
import 'package:office_mate/utils/custom_icons.dart';

class CreateWorkerDialog extends StatefulWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final String highlightColor;

  const CreateWorkerDialog({
    super.key, 
    required this.firstNameController,
    required this.lastNameController,
    required this.highlightColor,
  });

  @override
  State<CreateWorkerDialog> createState() => _CreateWorkerDialogState();
}

class _CreateWorkerDialogState extends State<CreateWorkerDialog> {
  int currentCreateWorkerStep = 0;

  void nextStep() {
    setState(() {
      currentCreateWorkerStep++;
    });
  }

  void goBack() {
    setState(() {
      currentCreateWorkerStep--;
    });
  }

  void reset() {
    setState(() {
      currentCreateWorkerStep = 0;
      widget.firstNameController.clear();
      widget.lastNameController.clear();
    });
  }

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
            Row(
              children: [
                const Text(
                  'New Staff Member',
                  style: TextStyle(
                    fontSize: AppConstants.mdFontSize,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryColor
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: SvgPicture.asset(
                    CustomIcons.close,
                    colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
                    height: AppConstants.lgCustomIconSize,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            DefaultTextField(
              controller: widget.firstNameController,
              highlightColor: widget.highlightColor,
              hintText: 'First Name',
            ),
            const SizedBox(height: 10),
            DefaultTextField(
              controller: widget.lastNameController,
              highlightColor: widget.highlightColor,
              hintText: 'Last Name',
            ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  currentCreateWorkerStep == 0 ? Icon(Icons.circle, size: 10, color: Color(int.parse(widget.highlightColor))) 
                    : Icon(Icons.trip_origin, size: 10, color: Color(int.parse(widget.highlightColor))),
                  currentCreateWorkerStep == 0 ? Icon(Icons.trip_origin, size: 10, color: Color(int.parse(widget.highlightColor))) 
                    : Icon(Icons.circle, size: 10, color: Color(int.parse(widget.highlightColor))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigator.of(context).pop();
                nextStep();
              },
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Color(int.parse(widget.highlightColor))),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(horizontal: 80, vertical: 12)
                )
              ),
              child: const Text(
                'NEXT',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}