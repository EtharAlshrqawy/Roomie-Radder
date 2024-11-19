import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:roomie_radar/components/RFCommonAppComponent.dart';
import 'package:roomie_radar/controllers/RFAuthController.dart';
import 'package:roomie_radar/models/UserModel.dart';
import 'package:roomie_radar/views/Auth/RFQuestionnaire.dart';
import 'package:roomie_radar/utils/RFColors.dart';
import 'package:roomie_radar/utils/RFWidget.dart';
import 'package:roomie_radar/views/Home/RFHomeScreen.dart';
import '../../utils/RFString.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';

class RFSignUpScreen extends StatefulWidget {
  const RFSignUpScreen({super.key});

  @override
  State<RFSignUpScreen> createState() => _RFSignUpScreenState();
}

class _RFSignUpScreenState extends State<RFSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  File? _profileImage;

  final TextEditingController phoneController = TextEditingController();
  final FocusNode fullNameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passWordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();

  String role = "tenant";
  String selectedCity = "Alexandria";
  bool _isLoading = false;

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

  void _showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: isError ? Colors.red : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImageToFirebase(File image) async {
    try {
      // Create a reference to the location you want to upload the image in Firebase Storage
      String fileName =
          'profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageReference =
          FirebaseStorage.instance.ref().child(fileName);

      // Upload the file to Firebase Storage
      UploadTask uploadTask = storageReference.putFile(image);
      TaskSnapshot snapshot = await uploadTask;

      // Retrieve the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Image upload failed: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RFCommonAppComponent(
            title: rfAppName,
            subTitle: rfAppSubTitle,
            mainWidgetHeight: 250,
            subWidgetHeight: 220,
            cardWidget: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Create an Account', style: boldTextStyle(size: 18)),
                    const SizedBox(height: 16),
                    _buildProfileImagePicker(),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: fullNameController,
                      focusNode: fullNameFocusNode,
                      nextFocusNode: emailFocusNode,
                      labelText: "Full Name",
                      textFieldType: TextFieldType.NAME,
                      validator: (value) {
                        if (value == null || value.split(' ').length < 2) {
                          return 'Please enter at least 2 words.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: emailController,
                      focusNode: emailFocusNode,
                      nextFocusNode: phoneFocusNode,
                      labelText: "Email Address",
                      textFieldType: TextFieldType.EMAIL,
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: phoneController,
                      focusNode: phoneFocusNode,
                      nextFocusNode: passWordFocusNode,
                      labelText: 'Phone Number',
                      textFieldType: TextFieldType.PHONE,
                      prefixText: '+20 ',
                      validator: (value) {
                        if (value == null || value.length < 10) {
                          return 'Please enter a valid phone number.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: passwordController,
                      focusNode: passWordFocusNode,
                      nextFocusNode: confirmPasswordFocusNode,
                      labelText: 'Password',
                      textFieldType: TextFieldType.PASSWORD,
                      validator: (value) {
                        if (value == null || value.length < 8) {
                          return 'Password must be at least 8 characters.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: confirmPasswordController,
                      focusNode: confirmPasswordFocusNode,
                      labelText: 'Confirm Password',
                      textFieldType: TextFieldType.PASSWORD,
                      validator: (value) {
                        if (value != passwordController.text) {
                          return 'Passwords do not match.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(),
                    const SizedBox(height: 16),
                    Text("Choose your role", style: boldTextStyle(size: 24)),
                    const SizedBox(height: 16),
                    _buildRoleSelection(),
                    const SizedBox(height: 32),
                    _buildCreateAccountButton(context),
                  ],
                ),
              ),
            ),
            subWidget: rfCommonRichText(
              title: "Have an account? ",
              subTitle: "Sign In Here",
            ).paddingAll(8).onTap(() {
              finish(context);
            }),
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

  Widget _buildProfileImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[300],
        backgroundImage:
            _profileImage != null ? FileImage(_profileImage!) : null,
        child: _profileImage == null
            ? Icon(Icons.camera_alt, color: Colors.grey[700], size: 50)
            : null,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    required String labelText,
    required TextFieldType textFieldType,
    String? prefixText,
    required String? Function(String?) validator,
  }) {
    return AppTextField(
      controller: controller,
      focus: focusNode,
      nextFocus: nextFocusNode,
      textFieldType: textFieldType,
      decoration: rfInputDecoration(
        lableText: labelText,
        showLableText: true,
        prefixText: prefixText,
        showPrefixText: prefixText != null,
        suffixIcon: Container(
          padding: const EdgeInsets.all(2),
          decoration: boxDecorationWithRoundedCorners(
            boxShape: BoxShape.circle,
            backgroundColor: rfRattingBgColor,
          ),
          child: const Icon(Icons.done, color: Colors.white, size: 14),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
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
    );
  }

  Widget _buildRoleSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildRoleButton(
          role: "tenant",
          imagePath: "images/tenant.png",
          label: "Tenant",
        ),
        const SizedBox(width: 16),
        _buildRoleButton(
          role: "lessor",
          imagePath: "images/lessor.png",
          label: "Lessor",
        ),
      ],
    );
  }

  Widget _buildRoleButton({
    required String role,
    required String imagePath,
    required String label,
  }) {
    return AppButton(
      color: this.role == role ? rfPrimaryColor : Colors.white,
      child: Column(
        children: [
          Image.asset(imagePath, height: 50),
          Text(label, style: boldTextStyle(size: 16)),
        ],
      ),
      onTap: () {
        setState(() {
          this.role = role;
        });
      },
    );
  }

  Widget _buildCreateAccountButton(BuildContext context) {
    return AppButton(
      color: rfPrimaryColor,
      width: context.width(),
      height: 45,
      elevation: 0,
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          setState(() {
            _isLoading = true;
          });

          String? profileImageUrl;
          if (_profileImage != null) {
            // Upload image to Firebase and get the download URL
            profileImageUrl = await _uploadImageToFirebase(_profileImage!);
          }

          if (profileImageUrl == null && _profileImage != null) {
            // Show an error message if the image upload failed
            _showSnackBar(context, 'Failed to upload profile image',
                isError: true);
            setState(() {
              _isLoading = false;
            });
            return;
          }

          // Call signUp with the profile image URL
          final response = await RFAuthController().signUp(
            UserModel(
              fullName: fullNameController.text,
              email: emailController.text,
              role: role,
              phone: phoneController.text,
              profileImageUrl: profileImageUrl ?? '',
              location: selectedCity,
            ),
            passwordController.text,
          );

          setState(() {
            _isLoading = false;
          });

          if (response['success']) {
            _showSnackBar(context, response['message']);
            var response2 = await RFAuthController()
                .signIn(emailController.text, passwordController.text);
            _showSnackBar(context, response2['message']);
            if (role == "tenant") {
              const QuestionnaireScreen().launch(context, isNewTask: true);
            } else if (role == "lessor") {
              const RFHomeScreen().launch(context);
            }
          } else {
            _showSnackBar(context, response['message'], isError: true);
          }
        }
      },
      child: Text('Create Account', style: boldTextStyle(color: white)),
    );
  }
}
