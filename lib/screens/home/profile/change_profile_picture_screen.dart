import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_app/firebase/storage.dart';
import 'package:pharmacy_app/utils/dialogs.dart';

class ChangeProfilePictureScreen extends StatefulWidget {
  const ChangeProfilePictureScreen({super.key});

  @override
  State<ChangeProfilePictureScreen> createState() =>
      _ChangeProfilePictureScreenState();
}

class _ChangeProfilePictureScreenState
    extends State<ChangeProfilePictureScreen> {
  StorageService storage = StorageService();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              final ImagePicker picker = ImagePicker();

              showCustomBottomSheet(
                context,
                [
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text('Take a photo'),
                    onTap: () {
                      picker
                          .pickImage(source: ImageSource.camera)
                          .then((pickedImage) {
                        Navigator.pop(context);
                        if (pickedImage != null) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              alignment: Alignment.center,
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.file(
                                      File(pickedImage.path),
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.grey[200]),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                  ),
                                  child: const Text(
                                    'CANCEL',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: .5),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);

                                    showLoadingDialog(context);
                                    storage
                                        .uploadProfileImage(pickedImage)
                                        .timeout(const Duration(minutes: 2))
                                        .then((p0) {
                                      Navigator.pop(
                                          _scaffoldKey.currentContext!);

                                      ScaffoldMessenger.of(
                                              _scaffoldKey.currentContext!)
                                          .showSnackBar(const SnackBar(
                                              content: Text('Photo updated!')));

                                      setState(() {});
                                    }).onError((error, stackTrace) {
                                      Navigator.pop(context);
                                      showAlertDialog(context,
                                          message: 'Error updating image');
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).primaryColor),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                  ),
                                  child: const Text(
                                    'UPLOAD PHOTO',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: .5),
                                  ),
                                ),
                              ],
                              actionsAlignment: MainAxisAlignment.center,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              actionsPadding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                            ),
                          );
                        }
                      }).onError((error, stackTrace) {
                        showAlertDialog(context);
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo),
                    title: const Text('Choose from gallery'),
                    onTap: () {
                      picker
                          .pickImage(source: ImageSource.gallery)
                          .then((pickedImage) {
                        Navigator.pop(context);
                        if (pickedImage != null) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              alignment: Alignment.center,
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.file(
                                      File(pickedImage.path),
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.grey[200]),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                  ),
                                  child: const Text(
                                    'CANCEL',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: .5),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);

                                    showLoadingDialog(context);
                                    storage
                                        .uploadProfileImage(pickedImage)
                                        .timeout(const Duration(minutes: 2))
                                        .then((p0) {
                                      Navigator.pop(context);
                                      setState(() {});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text('Photo updated!')));
                                    }).onError((error, stackTrace) {
                                      Navigator.pop(context);
                                      showAlertDialog(context,
                                          message: 'Error updating image');
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).primaryColor),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                  ),
                                  child: const Text(
                                    'UPLOAD PHOTO',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: .5),
                                  ),
                                ),
                              ],
                              actionsAlignment: MainAxisAlignment.center,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              actionsPadding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                            ),
                          );
                        }
                      }).onError((error, stackTrace) {
                        showAlertDialog(context);
                      });
                    },
                  ),
                ],
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: storage.profileImageDownloadUrl(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Icon(Icons.person));
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return CachedNetworkImage(
                imageUrl: snapshot.data,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator.adaptive(
                        value: downloadProgress.progress),
                errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.person)),
              );
            }

            return const Center(child: CircularProgressIndicator.adaptive());
          },
        ),
      ),
    );
  }
}
