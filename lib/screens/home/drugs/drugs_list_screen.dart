import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/firebase/storage.dart';
import 'package:pharmacy_app/models/drug.dart';
import 'package:pharmacy_app/models/pharmacy.dart';
import 'package:pharmacy_app/screens/home/checkout/checkout_page.dart';
import 'package:pharmacy_app/screens/home/drugs/drug_details_screen.dart';
import 'package:pharmacy_app/screens/home/drugs/drugs_search_delegate.dart';
import 'package:pharmacy_app/screens/home/profile/profile_screen.dart';
import 'package:pharmacy_app/utils/constants.dart';
import 'package:pharmacy_app/utils/functions.dart';

class DrugsListscreen extends StatelessWidget {
  const DrugsListscreen(
      {super.key, required this.pharmacy, required this.pharmacyDrugsList});
  final Pharmacy pharmacy;
  final List<Drug> pharmacyDrugsList;

  @override
  Widget build(BuildContext context) {
    List<Drug> drugsList = pharmacyDrugsList;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: kScreenWidth(context),
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(pharmacy.name!),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  ProfileImageWidget(
                    userId: pharmacy.id,
                    borderRadius: 0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(.55),
                          Colors.black.withOpacity(.0),
                          Colors.black.withOpacity(.0),
                          Colors.black.withOpacity(.55),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: StatefulBuilder(builder: (context, setState) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const Text('Drugs'),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            showSearch(
                                context: context,
                                delegate: DrugsSearchDelegate(
                                    pharmacyDrugsList: pharmacyDrugsList));
                          },
                          icon: const Icon(Icons.search),
                        ),
                        PopupMenuButton(
                          icon: const Icon(Icons.sort),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Sort by',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ListTile(
                                    title: const Text('Brand name'),
                                    onTap: () {
                                      List<Drug> temp = drugsList;
                                      temp.sort(((a, b) => a.brandName!
                                          .compareTo(b.brandName!)));

                                      drugsList = [...temp];
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('Generic name'),
                                    onTap: () {
                                      List<Drug> temp = drugsList;
                                      temp.sort(((a, b) => a.genericName!
                                          .compareTo(b.genericName!)));

                                      drugsList = [...temp];
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('Class'),
                                    onTap: () {
                                      List<Drug> temp = drugsList;
                                      temp.sort(((a, b) =>
                                          a.group!.compareTo(b.group!)));

                                      drugsList = [...temp];
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('Price'),
                                    onTap: () {
                                      List<Drug> temp = drugsList;
                                      temp.sort(((a, b) =>
                                          a.price!.compareTo(b.price!)));

                                      drugsList = [...temp];
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListView.separated(
                    padding: const EdgeInsets.all(20),
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: drugsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return DrugCard(drug: drugsList[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 20);
                    },
                  ),
                ],
              );
            }),
          )
        ],
      ),
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
            DrugDetailsScreen(
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
                  child: Text('GH¢ ${drug.price!.toStringAsFixed(2)}'),
                ),
                const Spacer(),
                drug.quantityInStock == 0
                    ? const Text(
                        'Out of stock',
                        style: TextStyle(color: Colors.grey),
                      )
                    : ValueListenableBuilder<Map<Drug, int>>(
                        valueListenable: cart,
                        builder: (context, value, child) {
                          return TextButton(
                            onPressed: () {
                              if (value.keys.contains(drug)) {
                                deleteFromCart(drug);
                              } else {
                                addToCart(drug);
                              }
                            },
                            child: Text(
                              value.keys.contains(drug)
                                  ? 'Remove from cart'
                                  : 'Add to cart',
                              style: TextStyle(
                                color: value.keys.contains(drug)
                                    ? Colors.orange
                                    : Colors.green,
                              ),
                            ),
                          );
                        },
                      ),
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

ValueNotifier<List<Drug>> drugsListNotifier = ValueNotifier([]);
