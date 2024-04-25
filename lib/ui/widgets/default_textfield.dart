import 'package:flutter/material.dart';
import 'package:office_mate/utils/constants.dart';

class DefaultTextField extends StatelessWidget {
  final TextEditingController controller;
  final String highlightColor;
  final String hintText;

  const DefaultTextField({
    super.key,
    required this.controller,
    required this.highlightColor,
    required this.hintText,
  });

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
          color: Color(int.parse(highlightColor)).withOpacity(0.2),
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
              style: const TextStyle(fontSize: AppConstants.smFontSize),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                fillColor: Colors.white,
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: AppColors.secondaryColor,
                  fontSize: AppConstants.smFontSize,
                ),
                border: InputBorder.none
              )
            ),
          ),
        ],
      ),
    );
  }
}