
import 'package:flutter/material.dart';
import 'package:office_mate/data/models/office.dart';
import 'package:office_mate/ui/screens/home_screen.dart';
import 'package:office_mate/ui/viewmodels/office_manager_viewmodel.dart';
import 'package:office_mate/ui/widgets/default_textfield.dart';
import 'package:office_mate/utils/constants.dart';
import 'package:office_mate/utils/office_colors.dart';
import 'package:provider/provider.dart';

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
  late bool isEditing;
  late Office office;
  int selectedColorIndex = 0;

  late final TextEditingController _officeNameController;
  late final TextEditingController _officeAddressController;
  late final TextEditingController _officeMaxCapacityController;
  late final TextEditingController _officePhoneController;
  late final TextEditingController _officeEmailController;

  @override
  void initState() {
    super.initState();

    isEditing = widget.isEditing;

    _officeNameController = TextEditingController();
    _officeAddressController = TextEditingController();
    _officeMaxCapacityController = TextEditingController();
    _officePhoneController = TextEditingController();
    _officeEmailController = TextEditingController();

    if (isEditing) {
      office = widget.office!;
      setState(() {
        selectedColorIndex = office.officeColorId - 1;
        // Set the text controllers to the values of the office being edited
        _officeNameController.text = office.name;
        _officeAddressController.text = office.location;
        _officeMaxCapacityController.text = office.officeCapacity.toString();
        _officePhoneController.text = office.phone;
        _officeEmailController.text = office.email;
      });
    }
  }

  void selectColor(int index) {
    setState(() {
      selectedColorIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color highlightColor = AppColors.primaryColor;

    OfficeManagerViewModel viewModel = Provider.of<OfficeManagerViewModel>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: Text(
            isEditing ? "Edit Office" : "Add Office",
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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Padding(
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
                          if (isEditing) {
                            viewModel.updateOffice(
                              _officeNameController.text,
                              _officeAddressController.text,
                              int.parse(_officeMaxCapacityController.text),
                              selectedColorIndex + 1,
                              _officeEmailController.text,
                              _officePhoneController.text,
                              widget.office!.officeId
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen()
                              )
                            );
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
                          elevation: WidgetStateProperty.all(0),
                          backgroundColor: WidgetStateProperty.all(
                            Color(int.parse(OfficeColors.getColors()[selectedColorIndex]))
                          ),
                          padding: WidgetStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(horizontal: 70, vertical: 13)
                          )
                        ),
                        child: Text(
                          isEditing ? "UPDATE OFFICE" : "ADD OFFICE",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: AppConstants.xsFontSize,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (isEditing)
                        TextButton(
                          onPressed: () {
                            viewModel.deleteOffice(widget.office!.officeId);
                            Navigator.pushReplacement(context, 
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen()
                              )
                            );
                          },
                          child: const Text(
                            "DELETE OFFICE",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: AppConstants.mdFontSize,
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
        Center(
          child: Wrap(
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
                        color: selectedIndex == index ? AppColors.primaryColor : Colors.transparent, // No ring when not selected
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
        ),
      ],
    );
  }
}