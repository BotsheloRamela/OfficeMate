import 'package:flutter/material.dart';
import 'package:office_mate/utils/constants.dart';
import 'package:office_mate/utils/custom_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class OfficeCard extends StatefulWidget {
  final String companyName;
  final int occupantsCount;
  final int officeCapacity;
  final String location;
  final String officeColor;
  final String email;
  final String phone;

  const OfficeCard({
    super.key, 
    required this.companyName, 
    required this.occupantsCount, 
    required this.officeCapacity,
    required this.location, 
    required this.officeColor, 
    required this.email, 
    required this.phone
  });

  @override
  State<OfficeCard> createState() => _OfficeCardState();
}

class _OfficeCardState extends State<OfficeCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white54,
      color: Colors.white,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(int.parse(widget.officeColor)).withOpacity(0.2), 
            width: 1
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ClipPath(
          clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9.0),
              side: BorderSide(
                color: Color(int.parse(widget.officeColor)).withOpacity(0.2),
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
                left: BorderSide(color: Color(int.parse(widget.officeColor)), width: 12),
              ),
            ) ,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                officeCardMainContent(
                  widget.companyName, 
                  widget.occupantsCount,
                  isExpanded,
                  () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  }
                ),
                if (isExpanded) 
                  officeCardExpandedContent(
                    widget.location, 
                    widget.email, 
                    widget.phone,
                    widget.officeCapacity
                  ),
              ],
            ),
          ),
  
        ),
      ),
    );
  }
}

Widget officeCardMainContent(
  String companyName, 
  int occupantsCount, 
  bool isExpanded,
  VoidCallback toggleExpansion
  ) {
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
          companyName,
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
              // TODO: Implement edit functionality
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
                  text: '$occupantsCount',
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
        onPressed: () {
          // Toggle the expansion state
          toggleExpansion();
        },
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

Widget officeCardExpandedContent(String location, String email, String phone, int officeCapacity) {
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
            phone,
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
            email,
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
            "Office Capacity: $officeCapacity",
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
            location,
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