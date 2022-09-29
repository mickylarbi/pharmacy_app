import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pharmacy_app/firebase/auth.dart';
import 'package:pharmacy_app/firebase/firestore.dart';
import 'package:pharmacy_app/firebase/storage.dart';
import 'package:pharmacy_app/models/patient.dart';
import 'package:pharmacy_app/screens/home/profile/change_profile_picture_screen.dart';
import 'package:pharmacy_app/screens/home/profile/register_pharmacy_screen.dart';
import 'package:pharmacy_app/utils/constants.dart';
import 'package:pharmacy_app/utils/dialogs.dart';
import 'package:pharmacy_app/utils/functions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  StorageService storage = StorageService();
  AuthService auth = AuthService();
  FirestoreService db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.grey[800], borderRadius: BorderRadius.circular(14)),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                child: FutureBuilder<String>(
                  future: storage.profileImageDownloadUrl(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Icon(Icons.person));
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              navigate(
                                  context, const ChangeProfilePictureScreen());
                            },
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  CachedNetworkImageProvider(snapshot.data!),
                            ),
                          ),
                        ],
                      );
                    }

                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(auth.currentUser!.email!),
            ],
          ),
        ),
        const SizedBox(height: 30),
        StatefulBuilder(builder: (context, setState) {
          return FutureBuilder(
              future: db.patientDocument().get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Column(
                    children: [
                      const Text('Could not retrive profile info'),
                      TextButton.icon(
                          onPressed: () {
                            setState(() {});
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reload'))
                    ],
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data!.data() == null) {
                    return Container();
                  }

                  Patient? patient = Patient.fromFirestore(
                      snapshot.data!.data()!, snapshot.data!.id);

                  return ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ListTile(
                        title: Text(patient.firstName!),
                        trailing: const Icon(Icons.edit),
                        onTap: () async {
                          String? result = await showEditDialog(
                              context, 'First name', patient.firstName!);

                          if (result != null) {
                            showLoadingDialog(context);
                            db
                                .patientDocument()
                                .update({'firstName': result})
                                .timeout(ktimeout)
                                .then((value) {
                                  Navigator.pop(context);
                                  setState(() {});
                                })
                                .onError((error, stackTrace) {
                                  Navigator.pop(context);
                                  showAlertDialog(context);
                                });
                          }
                        },
                        tileColor: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        title: Text(patient.surname!),
                        trailing: const Icon(Icons.edit),
                        onTap: () async {
                          String? result = await showEditDialog(
                              context, 'Surname', patient.surname!);

                          if (result != null) {
                            showLoadingDialog(context);
                            db
                                .patientDocument()
                                .update({'surname': result})
                                .timeout(ktimeout)
                                .then((value) {
                                  Navigator.pop(context);
                                  setState(() {});
                                })
                                .onError((error, stackTrace) {
                                  Navigator.pop(context);
                                  showAlertDialog(context);
                                });
                          }
                        },
                        tileColor: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        title: Text(patient.phone!),
                        trailing: const Icon(Icons.edit),
                        onTap: () async {
                          String? result = await showEditDialog(
                              context, 'Phone', patient.phone!);

                          if (result != null) {
                            showLoadingDialog(context);
                            db
                                .patientDocument()
                                .update({'phone': result})
                                .timeout(ktimeout)
                                .then((value) {
                                  Navigator.pop(context);
                                  setState(() {});
                                })
                                .onError((error, stackTrace) {
                                  Navigator.pop(context);
                                  showAlertDialog(context);
                                });
                          }
                        },
                        tileColor: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      const SizedBox(height: 50),
                      TextButton.icon(
                        onPressed: () {
                          navigate(
                              context,
                              RegisterPharmacyScreen(
                                name: patient.name,
                                phone: patient.phone!,
                              ));
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(14),
                          backgroundColor: Colors.yellow.withOpacity(.3),
                          foregroundColor: Colors.yellow,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.medical_services),
                        label: const Text('Register pharmacy'),
                      ),
                    ],
                  );
                }

                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              });
        }),
        const SizedBox(height: 20),
        TextButton.icon(
          onPressed: () {
            auth.signOut(context);
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(14),
            backgroundColor: Colors.red.withOpacity(.3),
            foregroundColor: Colors.red,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: const Icon(Icons.logout),
          label: const Text('Sign out'),
        ),
      ],
    );
  }
}

class ProfileImageWidget extends StatelessWidget {
  final String? userId;
  final double? height;
  final double? width;
  final double? borderRadius;

  ProfileImageWidget({
    Key? key,
    this.userId,
    this.height,
    this.width,
    this.borderRadius,
  }) : super(key: key);

  AuthService auth = AuthService();
  StorageService storage = StorageService();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return FutureBuilder<String>(
        future: storage.profileImageDownloadUrl(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return SizedBox(
              height: height,
              width: width,
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {});
                  },
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius ?? 14),
              child: CachedNetworkImage(
                imageUrl: snapshot.data!,
                height: height,
                width: width,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator.adaptive(
                      value: downloadProgress.progress),
                ),
                errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.person)),
              ),
            );
          }
          return SizedBox(
              height: height,
              width: width,
              child: const Center(child: CircularProgressIndicator.adaptive()));
        },
      );
    });
  }
}
