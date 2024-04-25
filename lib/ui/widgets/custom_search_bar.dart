import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:office_mate/utils/constants.dart';
import 'package:office_mate/utils/custom_icons.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  const CustomSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(
          color: AppColors.primaryColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.text,
              cursorColor: AppColors.primaryColor,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                fillColor: Colors.white,
                labelText: 'Search',
                labelStyle: TextStyle(
                  color: AppColors.secondaryColor,
                  fontSize: AppConstants.mdFontSize,
                ),
                border: InputBorder.none
              )
            ),
          ),
          SvgPicture.asset(
            CustomIcons.search,
            colorFilter: const ColorFilter.mode(AppColors.secondaryColor, BlendMode.srcIn),
            width: AppConstants.defaultCustomIconSize,
          ),
        ],
      ),
    );
  }
}