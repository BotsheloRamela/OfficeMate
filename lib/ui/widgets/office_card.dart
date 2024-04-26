import 'package:flutter/material.dart';
import 'package:office_mate/utils/constants.dart';
import 'package:office_mate/utils/custom_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import 'package:office_mate/utils/office_colors.dart';

class OfficeCard extends StatefulWidget {
  final String companyName;
  final int occupantsCount;
  final int officeCapacity;
  final String location;
  final int officeColorId;
  final String email;
  final String phone;
  final VoidCallback onEdit;

  const OfficeCard({
    super.key, 
    required this.companyName, 
    required this.occupantsCount, 
    required this.officeCapacity,
    required this.location, 
    required this.officeColorId, 
    required this.email, 
    required this.phone,
    required this.onEdit
  });

  @override
  State<OfficeCard> createState() => _OfficeCardState();
}

class _OfficeCardState extends State<OfficeCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: isExpanded ? 300 : 160,
      curve: Curves.easeInOut,
      child: Card(
        surfaceTintColor: Colors.white54,
        color: Colors.white,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(int.parse(OfficeColors.getColors()[
                widget.officeColorId - 1
              ])).withOpacity(0.2), 
              width: 1
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ClipPath(
            clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9.0),
                side: BorderSide(
                  color: Color(int.parse(OfficeColors.getColors()[
                    widget.officeColorId - 1
                  ])).withOpacity(0.2),
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            child: Container(
              width: double.infinity,
              // height: 100,
              // alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Color(int.parse(OfficeColors.getColors()[
                      widget.officeColorId - 1
                    ])), 
                    width: 12
                  ),
                ),
              ) ,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    officeCardMainContent(),
                    if (isExpanded) 
                      officeCardExpandedContent(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget officeCardMainContent() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
            widget.companyName,
              style: const TextStyle(
                fontSize: AppConstants.lgFontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryColor
              ),
            ),
            const Spacer(),
            IconButton(
              icon: SvgPicture.asset(
                CustomIcons.edit, 
                width: AppConstants.defaultCustomIconSize,
                colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
              ),
              onPressed: () {
                // Navigate to the office manager screen
                widget.onEdit();
              },
            )
          ],
        ),
        Row(
          children: [
            SvgPicture.asset(CustomIcons.people, width: AppConstants.defaultCustomIconSize),
            const SizedBox(width: 10),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${widget.occupantsCount}',
                    style: const TextStyle(
                      fontSize: AppConstants.smFontSize,
                      fontWeight: FontWeight.bold, // Making the count bold
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  const TextSpan(
                    text: ' Staff Members in Office',
                    style: TextStyle(
                      fontSize: AppConstants.smFontSize,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        const Divider(
          color: AppColors.secondaryColor,
          height: 1,
        ),
        // const SizedBox(height: 5),
        TextButton(
          onPressed: () => setState(() {
            isExpanded = !isExpanded;
          }),
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'More Info',
                style: TextStyle(
                  fontSize: AppConstants.xsFontSize,
                  color: AppColors.secondaryColor,
                ),
              ),
              const SizedBox(width: 10),
              Transform(
                alignment: Alignment.center,
                transform: isExpanded ? Matrix4.rotationX(math.pi) : Matrix4.rotationX(0),
                child: SvgPicture.asset(
                  CustomIcons.chevron,
                  width: AppConstants.defaultCustomIconSize,
                  colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget officeCardExpandedContent() {
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset(
              CustomIcons.phone, 
              width: AppConstants.defaultCustomIconSize,
              colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
            ),
            const SizedBox(width: 10),
            Text(
              widget.phone,
              style: const TextStyle(
                fontSize: AppConstants.xsFontSize,
                color: AppColors.secondaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            SvgPicture.asset(
              CustomIcons.email, 
              width: AppConstants.defaultCustomIconSize,
              colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
            ),
            const SizedBox(width: 10),
            Text(
              widget.email,
              style: const TextStyle(
                fontSize: AppConstants.xsFontSize,
                color: AppColors.secondaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            SvgPicture.asset(
              CustomIcons.filledPeople, 
              width: AppConstants.defaultCustomIconSize,
              colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
            ),
            const SizedBox(width: 10),
            Text(
              "Office Capacity: ${widget.officeCapacity}",
              style: const TextStyle(
                fontSize: AppConstants.xsFontSize,
                color: AppColors.secondaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            SvgPicture.asset(
              CustomIcons.location, 
              width: AppConstants.defaultCustomIconSize,
              colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
            ),
            const SizedBox(width: 10),
            Text(
              widget.location,
              style: const TextStyle(
                fontSize: AppConstants.xsFontSize,
                color: AppColors.secondaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

}

