
import 'package:flutter/material.dart';
import 'package:office_mate/data/models/office.dart';
import 'package:office_mate/ui/viewmodels/office_manager_viewmodel.dart';
import 'package:office_mate/ui/widgets/default_textfield.dart';
import 'package:office_mate/utils/constants.dart';
import 'package:office_mate/utils/office_colors.dart';

class OfficeManagerScreen extends StatefulWidget {
  final bool isEditing;
  final Office? office;

  const OfficeManagerScreen({
    super.key, 
    this.isEditing = false,
    this.office
  });

  @override
  State<OfficeManagerScreen> createState() => _OfficeManagerScreenState();
}

class _OfficeManagerScreenState extends State<OfficeManagerScreen> {
  final _officeNameController = TextEditingController();
  final _officeAddressController = TextEditingController();
  final _officeMaxCapacityController = TextEditingController();
  final _officePhoneController = TextEditingController();
  final _officeEmailController = TextEditingController();

  int selectedColorIndex = 0;

  void selectColor(int index) {
    setState(() {
      selectedColorIndex = index;
    });
  }

   @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      setState(() {
        selectedColorIndex = widget.office!.officeColorId - 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color highlightColor = AppColors.primaryColor;

    OfficeManagerViewModel viewModel = OfficeManagerViewModel();

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: Text(
            widget.isEditing ? "Edit Office" : "Add Office",
            style: const TextStyle(
              color: AppColors.secondaryColor,
              fontSize: AppConstants.mdFontSize,
              fontWeight: FontWeight.bold
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppConstants.horizontalAppPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              DefaultTextField(
                controller: _officeNameController, 
                highlightColor: highlightColor, 
                hintText: "Office Name"
              ),
              const SizedBox(height: 20),
              DefaultTextField(
                controller: _officeAddressController, 
                highlightColor: highlightColor, 
                hintText: "Physical Address"
              ),
              const SizedBox(height: 20),
               DefaultTextField(
                controller: _officePhoneController, 
                highlightColor: highlightColor, 
                hintText: "Phone Number",
                keyboardType: TextInputType.phone
              ),
              const SizedBox(height: 20),
              DefaultTextField(
                controller: _officeEmailController, 
                highlightColor: highlightColor, 
                hintText: "Email Address",
                keyboardType: TextInputType.emailAddress
              ),
              const SizedBox(height: 20),
              DefaultTextField(
                controller: _officeMaxCapacityController, 
                highlightColor: highlightColor, 
                hintText: "Maximum Capacity",
                keyboardType: TextInputType.number
              ),
              const SizedBox(height: 30),
              newOfficeColor(selectColor, selectedColorIndex),
              const SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (widget.isEditing) {
                          viewModel.updateOffice(
                            _officeNameController.text,
                            _officeAddressController.text,
                            int.parse(_officeMaxCapacityController.text),
                            selectedColorIndex + 1,
                            _officeEmailController.text,
                            _officePhoneController.text,
                            widget.office!.officeId
                          );
                          Navigator.pop(context);
                        } else {
                          viewModel.createOffice(
                            _officeNameController.text,
                            _officeAddressController.text,
                            int.parse(_officeMaxCapacityController.text),
                            selectedColorIndex + 1,
                            _officeEmailController.text,
                            _officePhoneController.text
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor: MaterialStateProperty.all(
                          Color(int.parse(OfficeColors.getColors()[selectedColorIndex]))
                        ),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(horizontal: 70, vertical: 13)
                        )
                      ),
                      child: Text(
                        widget.isEditing ? "UPDATE OFFICE" : "ADD OFFICE",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: AppConstants.xsFontSize,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (widget.isEditing)
                      TextButton(
                        onPressed: () {
                          viewModel.deleteOffice(widget.office!.officeId);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "DELETE OFFICE",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: AppConstants.xsFontSize,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget newOfficeColor(
    void Function(int) selectColor, 
    int selectedIndex,
  ) {
    List<String> colors = OfficeColors.getColors();
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Office Colour",
          style: TextStyle(
            color: AppColors.secondaryColor,
            fontSize: AppConstants.lgFontSize,
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10.0,
          runSpacing: 20.0,
          children: [
            for (int index = 0; index < colors.length; index++)
              GestureDetector(
                onTap: () {
                  selectColor(colors.indexOf(colors[index]));
                },
                child: Container(
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selectedIndex == index
                          ? AppColors.primaryColor
                          : Colors.transparent, // No ring when not selected
                      width: 3.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(int.parse(colors[index])),
                  ),
                )
              ),
          ],
        ),
      ],
    );
  }
}