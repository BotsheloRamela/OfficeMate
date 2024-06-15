
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:office_mate/ui/widgets/default_textfield.dart';
import 'package:office_mate/utils/avatar_icons.dart';
import 'package:office_mate/utils/constants.dart';
import 'package:office_mate/utils/custom_icons.dart';

class WorkerDialog extends StatefulWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final Color highlightColor;
  final void Function(int) saveWorker;
  final bool isEditing;
  final int? avatarId;
  final String? workerId;

  const WorkerDialog({
    super.key, 
    required this.firstNameController,
    required this.lastNameController,
    required this.highlightColor,
    required this.saveWorker,
    required this.isEditing,
    this.avatarId,
    this.workerId
  });

  @override
  State<WorkerDialog> createState() => _WorkerDialogState();
}

class _WorkerDialogState extends State<WorkerDialog> {
  int currentDialogStep = 0;
  int selectedAvatar = 0;
  late List<String> avatars;

  void nextStep() {
    setState(() {
      currentDialogStep++;
    });
  }

  void goBack() {
    setState(() {
      currentDialogStep--;
    });
  }

  void selectAvatar(int index) {
    setState(() {
      selectedAvatar = index;
    });
  }

  @override
  void initState() {
    super.initState();
    avatars = AvatarIcons.getAllAvatars();
    if (widget.isEditing) {
      setState(() {
        selectedAvatar = widget.avatarId!;
      });
    }
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
                if (currentDialogStep == 1)
                  GestureDetector(
                    onTap: goBack,
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.secondaryColor,
                      size: AppConstants.defaultCustomIconSize,
                    )
                  ),
                Text(
                  widget.isEditing ? 'Edit Staff Member' : 'New Staff Member',
                  style: const TextStyle(
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
            if (currentDialogStep == 0)
              newMemberDetails(
                widget.firstNameController,
                widget.lastNameController,
                widget.highlightColor
              ),
            if (currentDialogStep == 1)
              Center(child: newMemberAvatar(selectAvatar, selectedAvatar, widget.highlightColor)),
            const SizedBox(height: 25),
            Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  currentDialogStep == 0 ? Icon(Icons.circle, size: 10, color: widget.highlightColor) 
                    : Icon(Icons.trip_origin, size: 10, color: widget.highlightColor),
                  currentDialogStep == 0 ? Icon(Icons.trip_origin, size: 10, color: widget.highlightColor) 
                    : Icon(Icons.circle, size: 10, color: widget.highlightColor),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  currentDialogStep == 0 ? nextStep() 
                    : {
                      widget.saveWorker(
                        // Pass the selected avatar id + 1 to match the index
                        selectedAvatar
                      ),
                      Navigator.of(context).pop()
                    };
                },
                style: ButtonStyle(
                  elevation: WidgetStateProperty.all(0),
                  backgroundColor: WidgetStateProperty.all(widget.highlightColor),
                  padding: WidgetStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12)
                  )
                ),
                child: Text(
                  (widget.isEditing && currentDialogStep == 1) ? 'UPDATE STAFF MEMBER' 
                  : (currentDialogStep == 0 ? 'NEXT' 
                  : 'ADD STAFF MEMBER'),
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

  Widget newMemberAvatar(void Function(int) selectAvatar, int selectedIndex, Color higlightColor) {
    
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

}

