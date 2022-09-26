import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_app/firebase/auth.dart';
import 'package:pharmacy_app/firebase/firestore.dart';
import 'package:pharmacy_app/firebase/storage.dart';
import 'package:pharmacy_app/models/patient.dart';
import 'package:pharmacy_app/models/pharmacy.dart';
import 'package:pharmacy_app/utils/constants.dart';
import 'package:pharmacy_app/utils/dialogs.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  ValueNotifier<XFile?> pictureNotifier = ValueNotifier<XFile?>(null);
  TextEditingController firstNameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  ValueListenableBuilder<XFile?>(
                      valueListenable: pictureNotifier,
                      builder: (context, value, child) {
                        final ImagePicker picker = ImagePicker();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                              .pickImage(
                                                  source: ImageSource.camera)
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
                                        title:
                                            const Text('Choose from gallery'),
                                        onTap: () async {
                                          picker
                                              .pickImage(
                                                  source: ImageSource.gallery)
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14),
                                  backgroundColor:
                                      Colors.blueGrey.withOpacity(.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(value == null
                                    ? 'Choose photo'
                                    : 'Change photo'),
                              ),
                            ),
                          ],
                        );
                      }),
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'First name',
                    ),
                    controller: firstNameController,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Last name',
                    ),
                    textCapitalization: TextCapitalization.words,
                    controller: surnameController,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Phone',
                    ),
                    keyboardType: TextInputType.number,
                    controller: phoneController,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: elevatedButtonStyle,
                    onPressed: () {
                      if (firstNameController.text.trim().isNotEmpty &&
                          surnameController.text.trim().isNotEmpty &&
                          phoneController.text.trim().isNotEmpty) {
                        FirestoreService db = FirestoreService();
                        StorageService storage = StorageService();

                        if (pictureNotifier.value == null) {
                          db
                              .addPatient(
                            Patient(
                              firstName: firstNameController.text.trim(),
                              surname: surnameController.text.trim(),
                              phone: phoneController.text.trim(),
                            ),
                          )
                              .then((value) {
                            AuthService auth = AuthService();

                            auth.authFunction(context);
                          }).onError((error, stackTrace) {
                            Navigator.pop(context);
                            showAlertDialog(context,
                                message: 'Error uploading info');
                          });
                        } else {
                          storage
                              .uploadProfileImage(pictureNotifier.value!)
                              .timeout(const Duration(minutes: 2))
                              .then((p0) {
                            db
                                .addPatient(
                              Patient(
                                firstName: firstNameController.text.trim(),
                                surname: surnameController.text.trim(),
                                phone: phoneController.text.trim(),
                              ),
                            )
                                .then((value) {
                              AuthService auth = AuthService();

                              auth.authFunction(context);
                            }).onError((error, stackTrace) {
                              Navigator.pop(context);
                              showAlertDialog(context,
                                  message: 'Error uploading info');
                            });
                          }).onError((error, stackTrace) {
                            Navigator.pop(context);
                            showAlertDialog(context,
                                message: 'Error uploading info');
                          });
                        }
                      }
                    },
                    child: const Text('Upload info'),
                  ),
                  // TextButton(
                  //     onPressed: () {
                  //       AuthService auth = AuthService();
                  //       auth.signOut(context);
                  //     },
                  //     child: const Text('signout'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
