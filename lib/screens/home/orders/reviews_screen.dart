import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_app/firebase/firestore.dart';
import 'package:pharmacy_app/models/patient.dart';
import 'package:pharmacy_app/models/review.dart';
import 'package:pharmacy_app/screens/home/profile/profile_screen.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirestoreService db = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: db.instance.collection('reviews').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('An error occured.'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            List<Review> reviewsList = snapshot.data!.docs
                .map((e) => Review.fromFirestore(e.data(), e.id))
                .toList();

            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: reviewsList.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ProfileImageWidget(
                          userId: reviewsList[index].userId,
                          height: 50,
                          width: 50,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<
                                      DocumentSnapshot<Map<String, dynamic>>>(
                                  future: db.instance
                                      .collection('patients')
                                      .doc(reviewsList[index].userId)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {}

                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      Patient patient = Patient.fromFirestore(
                                          snapshot.data!.data()!,
                                          snapshot.data!.id);

                                      print(patient.name);

                                      return Text(patient.name);
                                    }

                                    return const Center(
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    );
                                  }),
                              const SizedBox(width: 14),
                              Text(
                                DateFormat.yMd()
                                    .add_jm()
                                    .format(reviewsList[index].dateTime!),
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        Text(reviewsList[index].rating!.toStringAsFixed(2)),
                      ],
                    ),
                    Text(reviewsList[index].comment!),
                  ],
                );
              },
              separatorBuilder: (context, index) => const Divider(height: 50),
            );
          }),
    );
  }
}
