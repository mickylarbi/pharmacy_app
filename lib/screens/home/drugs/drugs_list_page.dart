import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/firebase/firestore.dart';
import 'package:pharmacy_app/firebase/storage.dart';
import 'package:pharmacy_app/models/drug.dart';
import 'package:pharmacy_app/screens/home/drugs/drug_details_screen.dart';
import 'package:pharmacy_app/screens/home/drugs/drugs_search_delegate.dart';
import 'package:pharmacy_app/utils/functions.dart';

class DrugsPage extends StatefulWidget {
  const DrugsPage({super.key});

  @override
  State<DrugsPage> createState() => _DrugsListPageState();
}

class _DrugsListPageState extends State<DrugsPage> {
  FirestoreService db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: db.drugsCollection.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: TextButton(
              onPressed: () {
              },
              child: const Text('Reload'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        List<Drug> drugsList = snapshot.data!.docs
            .map((e) => Drug.fromFirestore(e.data(), e.id))
            .toList();

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: drugsList.length,
          itemBuilder: (BuildContext context, int index) {
            return DrugCard(drug: drugsList[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 20);
          },
        );
      },
    );
  }
}

class DrugCard extends StatelessWidget {
  final Drug drug;
  const DrugCard({super.key, required this.drug});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigate(
            context,
            DrugDetails(
              drug: drug,
            ));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Row(
              children: [
                DrugImageWidget(
                  drugId: drug.id!,
                  height: 100,
                  width: 100,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: SizedBox(
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          drug.brandName!,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          drug.genericName!,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          drug.group!,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                    width: 100,
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    child: Text('GH¢ ${drug.price!.toStringAsFixed(2)}')),
                const Spacer(),
                TextButton(onPressed: () {}, child: const Text('Add to cart')),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DrugImageWidget extends StatelessWidget {
  final String drugId;
  final double? height;
  final double? width;
  final double? borderRadius;
  DrugImageWidget(
      {Key? key,
      required this.drugId,
      this.height,
      this.width,
      this.borderRadius})
      : super(key: key);

  StorageService storage = StorageService();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return FutureBuilder(
          future: storage.drugImageDownloadUrl(drugId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                  fit: BoxFit.fitWidth,
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
              child: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          },
        );
      },
    );
  }
}
