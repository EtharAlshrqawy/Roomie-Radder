import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_radar/components/RFCommonAppComponent.dart';
import 'package:roomie_radar/controllers/RFAuthController.dart';
import 'package:roomie_radar/main.dart';
import 'package:roomie_radar/utils/RFColors.dart';
import 'package:roomie_radar/utils/RFWidget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  String selectedCity = "Alexandria"; // Default city
  final List<String> cities = [
    "Cairo",
    "Alexandria",
    "Giza",
    "Shubra El-Kheima",
    "Port Said",
    "Suez",
    "Luxor",
    "Aswan",
    "Asyut",
    "Ismailia",
    "Fayoum",
    "Tanta",
    "Damanhur",
    "Beni Suef",
    "Zagazig",
    "Mansoura",
    "Minya",
    "Sohag",
    "Qena",
    "Hurghada",
    "Damietta",
    "Kafr El Sheikh",
    "Shibin El Kom",
    "Banha",
    "El-Mahalla El-Kubra",
    "6th of October City",
    "Sadat City",
    "New Cairo",
    "Sheikh Zayed City"
  ];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: userModel!.fullName);
    selectedCity = userModel!.location;
    _phoneController = TextEditingController(text: userModel!.phone);
    init();
  }

  void init() async {
    setStatusBarColor(rfPrimaryColor,
        statusBarIconBrightness: Brightness.light);
  }

  void _showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: isError ? Colors.red : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading
      });

      userModel!.fullName = _nameController.text;
      userModel!.location = selectedCity;
      userModel!.phone = _phoneController.text;

      final response = await RFAuthController().updateUserData(userModel!);

      setState(() {
        _isLoading = false; // Stop loading
      });

      if (response['success']) {
        _showSnackBar(context, response['message']);
        Navigator.pop(context, true);
      } else {
        _showSnackBar(context, response['message'], isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RFCommonAppComponent(
            title: "Edit Profile",
            mainWidgetHeight: 250,
            cardWidget: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Edit Profile', style: boldTextStyle(size: 18)),
                  16.height,
                  AppTextField(
                    controller: _nameController,
                    textFieldType: TextFieldType.NAME,
                    decoration: rfInputDecoration(
                      lableText: "Full Name",
                      showLableText: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  16.height,
                  DropdownButtonFormField<String>(
                    value: selectedCity,
                    onChanged: (newValue) {
                      setState(() {
                        selectedCity = newValue!;
                      });
                    },
                    items: cities.map((city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Select City',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a city.';
                      }
                      return null;
                    },
                  ),
                  16.height,
                  AppTextField(
                    controller: _phoneController,
                    textFieldType: TextFieldType.PHONE,
                    decoration: rfInputDecoration(
                      lableText: "Phone Number",
                      showLableText: true,
                      showPrefixText: true,
                      prefixText: "+20",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  32.height,
                  AppButton(
                    color: rfPrimaryColor,
                    width: context.width(),
                    height: 45,
                    elevation: 0,
                    onTap: _updateProfile,
                    child: Text('Save Changes',
                        style: boldTextStyle(color: white)),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(rfPrimaryColor),
              ),
            ),
        ],
      ),
    );
  }
}
