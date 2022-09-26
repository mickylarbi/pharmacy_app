import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_app/firebase/auth.dart';
import 'package:pharmacy_app/firebase/firestore.dart';
import 'package:pharmacy_app/firebase/storage.dart';
import 'package:pharmacy_app/models/pharmacy.dart';
import 'package:pharmacy_app/utils/constants.dart';
import 'package:pharmacy_app/utils/dialogs.dart';

class RegisterPharmacyScreen extends StatefulWidget {
  final String name;
  final String phone;
  const RegisterPharmacyScreen(
      {super.key, required this.name, required this.phone});

  @override
  State<RegisterPharmacyScreen> createState() => _RegisterPharmacyScreenState();
}

class _RegisterPharmacyScreenState extends State<RegisterPharmacyScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  ValueNotifier<XFile?> pictureNotifier = ValueNotifier<XFile?>(null);
  FocusNode focusNode = FocusNode();

  FirestoreService db = FirestoreService();
  StorageService storage = StorageService();

  @override
  void initState() {
    super.initState();

    nameController.text = widget.name;
    phoneController.text = widget.phone;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register pharmacy'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            photoColumn(),
            const Divider(height: 100),
            nameColumn(),
            const Divider(height: 100),
            phoneColumn(),
            const Divider(height: 100),
            createPharmacyButton(),
          ],
        ),
      ),
    );
  }

  Align createPharmacyButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 52 + 72,
        child: Padding(
          padding: const EdgeInsets.all(36),
          child: ElevatedButton(
            onPressed: () {
              onButtonPressed();
            },
            style: elevatedButtonStyle,
            child: const Text('Create pharmacy'),
          ),
        ),
      ),
    );
  }

  photoColumn() {
    return ValueListenableBuilder<XFile?>(
        valueListenable: pictureNotifier,
        builder: (context, value, child) {
          final ImagePicker picker = ImagePicker();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add a logo',
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              if (value != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(
                      File(value.path),
                      height: 250,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    showCustomBottomSheet(
                      context,
                      [
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: const Text('Take a photo'),
                          onTap: () async {
                            picker
                                .pickImage(source: ImageSource.camera)
                                .then((value) {
                              Navigator.pop(context);
                              if (value != null) {
                                pictureNotifier.value = value;
                              }
                            }).onError((error, stackTrace) {
                              showAlertDialog(context);
                            });
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.photo),
                          title: const Text('Choose from gallery'),
                          onTap: () async {
                            picker
                                .pickImage(source: ImageSource.gallery)
                                .then((value) {
                              Navigator.pop(context);
                              if (value != null) {
                                pictureNotifier.value = value;
                              }
                            }).onError((error, stackTrace) {
                              showAlertDialog(context);
                            });
                          },
                        ),
                      ],
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    backgroundColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    value == null ? 'Choose photo' : 'Change photo',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        });
  }

  nameColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What\'s the name of your pharmacy?',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextFormField(
          decoration: const InputDecoration(hintText: 'Pharmacy name'),
          controller: nameController,
          onFieldSubmitted: (value) {
            focusNode.requestFocus();
          },
        ),
      ],
    );
  }

  phoneColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How should we contact you?',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextFormField(
          decoration: const InputDecoration(hintText: 'Phone number'),
          controller: phoneController,
          keyboardType: TextInputType.phone,
          focusNode: focusNode,
          onFieldSubmitted: (value) {
            onButtonPressed();
          },
        ),
      ],
    );
  }

  onButtonPressed() {
    showConfirmationDialog(context, message: 'Create pharmacy?',
        confirmFunction: () {
      if (nameController.text.trim().isNotEmpty &&
          phoneController.text.trim().isNotEmpty &&
          phoneController.text.trim().length >= 10) {
        showLoadingDialog(context);
        if (pictureNotifier.value == null) {
          db
              .addAdmin(Pharmacy(
                  name: nameController.text.trim(),
                  phone: phoneController.text.trim()))
              .timeout(ktimeout)
              .then((value) {
            AuthService auth = AuthService();
            auth.authFunction(context);
          }).onError((error, stackTrace) {
            Navigator.pop(context);
            showAlertDialog(context, message: 'Error while creating pharmacy');
          });
        } else {
          storage
              .uploadProfileImage(pictureNotifier.value!)
              .timeout(const Duration(minutes: 2))
              .then((value) {
            db
                .addAdmin(Pharmacy(
                    name: nameController.text.trim(),
                    phone: phoneController.text.trim()))
                .timeout(ktimeout)
                .then((value) {
              AuthService auth = AuthService();
              auth.authFunction(context);
            }).onError((error, stackTrace) {
              Navigator.pop(context);
              showAlertDialog(context,
                  message: 'Error while creating pharmacy');
            });
          }).onError((error, stackTrace) {
            Navigator.pop(context);
            showAlertDialog(context, message: 'Error while creating pharmacy');
          });
        }
      } else if (nameController.text.trim().isEmpty) {
        showAlertDialog(context,
            message: 'Please enter a name for your pharmacy');
      } else if (phoneController.text.trim().isEmpty) {
        showAlertDialog(context, message: 'Please enter a phone number');
      } else if (phoneController.text.trim().length < 10) {
        showAlertDialog(context, message: 'Please enter a valid phone number');
      }
    });
  }
}
