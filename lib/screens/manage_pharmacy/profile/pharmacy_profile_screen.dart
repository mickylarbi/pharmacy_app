import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pharmacy_app/firebase/auth.dart';
import 'package:pharmacy_app/firebase/firestore.dart';
import 'package:pharmacy_app/firebase/storage.dart';
import 'package:pharmacy_app/models/patient.dart';
import 'package:pharmacy_app/models/pharmacy.dart';
import 'package:pharmacy_app/screens/home/profile/change_profile_picture_screen.dart';
import 'package:pharmacy_app/screens/home/profile/register_pharmacy_screen.dart';
import 'package:pharmacy_app/utils/constants.dart';
import 'package:pharmacy_app/utils/dialogs.dart';
import 'package:pharmacy_app/utils/functions.dart';

class PharmacyProfileScreen extends StatefulWidget {
  const PharmacyProfileScreen({super.key});

  @override
  State<PharmacyProfileScreen> createState() => _PharmacyProfileScreenState();
}

class _PharmacyProfileScreenState extends State<PharmacyProfileScreen> {
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
              future: db.pharmacyDocument().get(),
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

                  Pharmacy pharmacy = Pharmacy.fromFirestore(
                      snapshot.data!.data()!, snapshot.data!.id);

                  return ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ListTile(
                        title: Text(pharmacy.name!),
                        trailing: const Icon(Icons.edit),
                        onTap: () async {
                          String? result = await showEditDialog(
                              context, 'Name', pharmacy.name!);

                          if (result != null) {
                            showLoadingDialog(context);
                            db
                                .patientDocument()
                                .update({'name': result})
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
                        title: Text(pharmacy.phone!),
                        trailing: const Icon(Icons.edit),
                        onTap: () async {
                          String? result = await showEditDialog(
                              context, 'Phone', pharmacy.phone!);

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
                    ],
                  );
                }

                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              });
        }),
        const SizedBox(height: 50),
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
