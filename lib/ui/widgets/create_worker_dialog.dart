
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:office_mate/ui/widgets/default_textfield.dart';
import 'package:office_mate/utils/avatar_icons.dart';
import 'package:office_mate/utils/constants.dart';
import 'package:office_mate/utils/custom_icons.dart';

class CreateWorkerDialog extends StatefulWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final Color highlightColor;

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
  int selectedAvatar = 0;

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

  void selectAvatar(int index) {
    setState(() {
      selectedAvatar = index;
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentCreateWorkerStep == 1)
                  GestureDetector(
                    onTap: goBack,
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.secondaryColor,
                      size: AppConstants.defaultCustomIconSize,
                    )
                  ),
                const Text(
                  'New Staff Member',
                  style: TextStyle(
                    fontSize: AppConstants.mdFontSize,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryColor
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: SvgPicture.asset(
                    CustomIcons.close,
                    colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
                    height: AppConstants.defaultCustomIconSize,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            if (currentCreateWorkerStep == 0)
              newMemberDetails(
                widget.firstNameController,
                widget.lastNameController,
                widget.highlightColor
              ),
            if (currentCreateWorkerStep == 1)
              newMemberAvatar(selectAvatar, selectedAvatar, widget.highlightColor),
            const SizedBox(height: 25),
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  currentCreateWorkerStep == 0 ? Icon(Icons.circle, size: 10, color: widget.highlightColor) 
                    : Icon(Icons.trip_origin, size: 10, color: widget.highlightColor),
                  currentCreateWorkerStep == 0 ? Icon(Icons.trip_origin, size: 10, color: widget.highlightColor) 
                    : Icon(Icons.circle, size: 10, color: widget.highlightColor),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                  nextStep();
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.all(widget.highlightColor),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 12)
                  )
                ),
                child: Text(
                  currentCreateWorkerStep == 0 ? 'NEXT' : 'ADD STAFF MEMBER',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: AppConstants.xsFontSize
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget newMemberDetails(
  TextEditingController firstNameController, 
  TextEditingController lastNameController, 
  Color highlightColor
  ) {
  return Column(
    children: [
       DefaultTextField(
        controller: firstNameController,
        highlightColor: highlightColor,
        hintText: 'First Name',
      ),
      const SizedBox(height: 10),
      DefaultTextField(
        controller: lastNameController,
        highlightColor: highlightColor,
        hintText: 'Last Name',
      ),
    ],
  );
}

Widget newMemberAvatar(
  void Function(int) selectAvatar, 
  int selectedIndex,
  Color higlightColor
  ){
  List<String> avatars = AvatarIcons.getAllAvatars();
  
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Avatar",
        style: TextStyle(
          color: AppColors.secondaryColor,
          fontSize: AppConstants.mdFontSize,
          fontWeight: FontWeight.bold
        ),
      ),
      const SizedBox(height: 20),
      Wrap(
        alignment: WrapAlignment.center,
        spacing: 10.0,
        runSpacing: 20.0,
        children: [
          for (int index = 0; index < avatars.length; index++)
            GestureDetector(
              onTap: () {
                selectAvatar(avatars.indexOf(avatars[index]));
              },
              child: Container(
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selectedIndex == index
                        ? higlightColor
                        : Colors.transparent, // No ring when not selected
                    width: 3.0,
                  ),
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(avatars[index]),
                ),
              )
            ),
        ],
      ),
    ],
  );
}