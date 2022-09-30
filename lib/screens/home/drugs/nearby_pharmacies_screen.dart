import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharmacy_app/models/pharmacy.dart';
import 'package:pharmacy_app/screens/home/drugs/pharmacies_list_page.dart';

class NearbyPharmaciesScreen extends StatefulWidget {
  const NearbyPharmaciesScreen({super.key, required this.currentLocation});

  final LatLng currentLocation;

  @override
  State<NearbyPharmaciesScreen> createState() => _NearbyPharmaciesScreenState();
}

class _NearbyPharmaciesScreenState extends State<NearbyPharmaciesScreen> {
  late GoogleMapController mapController;
  PageController pageController = PageController(viewportFraction: 0.8);
  late List<Pharmacy> nearbyPharamciesList;

  @override
  void initState() {
    super.initState();
    nearbyPharamciesList = pharmaciesList;

    nearbyPharamciesList.sort((a, b) => sqrt(pow(
                a.location!.latitude - widget.currentLocation.latitude, 2) +
            pow(a.location!.longitude - widget.currentLocation.longitude, 2))
        .compareTo(sqrt(pow(
                b.location!.latitude - widget.currentLocation.latitude, 2) +
            pow(b.location!.longitude - widget.currentLocation.longitude, 2))));

    nearbyPharamciesList = nearbyPharamciesList.reversed.toList();

    pageController.addListener(
      () {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                  nearbyPharamciesList[pageController.page!.round()]
                      .location!
                      .latitude,
                  nearbyPharamciesList[pageController.page!.round()]
                      .location!
                      .longitude),
              zoom: 14,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(nearbyPharamciesList[0].location!.latitude,
                  nearbyPharamciesList[0].location!.longitude),
              zoom: 14.4746,
            ),
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: onMapCreated,
            markers: nearbyPharamciesList
                .map(
                  (e) => Marker(
                    markerId: MarkerId(e.id!),
                    position:
                        LatLng(e.location!.latitude, e.location!.longitude),
                  ),
                )
                .toSet(),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: 54,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Material(
                  color: Colors.grey[50],
                  elevation: 10,
                  borderRadius: BorderRadius.circular(16),
                  child: IconButton(
                    color: Colors.blueGrey,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FloatingActionButton(
                        elevation: 10,
                        backgroundColor: Colors.grey[50],
                        foregroundColor: Colors.blueGrey,
                        onPressed: () async {
                          var result = await getCurrentLocation();

                          if (result != null) {
                            mapController.animateCamera(
                                CameraUpdate.newCameraPosition(
                                    CameraPosition(target: result, zoom: 18)));
                          }
                        },
                        child: const Icon(Icons.my_location),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 140,
                    child: PageView.builder(
                      controller: pageController,
                      scrollDirection: Axis.horizontal,
                      itemCount: nearbyPharamciesList.length,
                      itemBuilder: (context, index) {
                        Pharmacy pharmacy = nearbyPharamciesList[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: PharmacyCard(
                              pharmacy: pharmacy, drugsList: drugListGlobal),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void dispose() {
    mapController.dispose();

    super.dispose();
  }
}

Future getCurrentLocation() async {
  bool? serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    // return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  Position currentPosition = await Geolocator.getCurrentPosition();
  return LatLng(currentPosition.latitude, currentPosition.longitude);
}
