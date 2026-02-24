import 'dart:convert';
import 'package:ohresto/Pages/details.dart';
import 'package:ohresto/Pages/livrable.dart';
import 'package:ohresto/Structures/details_structure.dart';
import 'package:ohresto/Structures/detailsp_structure.dart';
import 'package:ohresto/Structures/menu_structure.dart';
import 'package:ohresto/Structures/resto_structure.dart';
import 'package:ohresto/config.dart';
import 'package:ohresto/controller_api/details_api.dart';
import 'package:ohresto/controller_api/detailsp_api.dart';
import 'package:ohresto/controller_api/menu_api.dart';
import 'package:ohresto/controller_api/resto_api.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  late Future<List<Menus>> menuFuture;
  late Future<List<Restaurants>> restoFuture;
  late TabController _tabController;
  late Future<Position> _currentPositionFuture;
  String localLongitude = "";
  String localLatitude = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    menuFuture = fetchmenus();
    restoFuture = fetchrestos();
    _currentPositionFuture = determinePosition();
    _checkHums();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _checkHums() async {
    final prefs = await SharedPreferences.getInstance();
    final uri = Uri.parse("${api_link}/nbhums.php");
    var data = {"user": prefs.getString("username") ?? ""};
    var res = await http.post(uri, body: data);

    if (res.statusCode == 200) {
      if (jsonDecode(res.body) == "pas de compte") {
        Fluttertoast.showToast(msg: "Erroné", toastLength: Toast.LENGTH_SHORT);
        return;
      }

      final jData = jsonDecode(res.body);
      final result = int.parse(jData[0]["total"]) / 10;
      prefs.setString('etoile', result.round().toString());
    }
  }

  void _getCurrentLocation() async {
    final geoposition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      localLatitude = '${geoposition.latitude}';
      localLongitude = '${geoposition.longitude}';
    });
  }

  Future<double> getDistanceFromCurrentPosition({
    required double targetLatitude,
    required double targetLongitude,
  }) async {
    // Récupération de la position actuelle
    final Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Calcul de la distance
    final Distance distance = Distance();

    final double distanceInKm = distance.as(
      LengthUnit.Kilometer,
      LatLng(currentPosition.latitude, currentPosition.longitude),
      LatLng(targetLatitude, targetLongitude),
    );

    return distanceInKm;
  }

  double calculateDistanceFromPosition({
    required Position currentPosition,
    required double targetLatitude,
    required double targetLongitude,
  }) {
    final distance = Distance();

    return distance.as(
      LengthUnit.Kilometer,
      LatLng(currentPosition.latitude, currentPosition.longitude),
      LatLng(targetLatitude, targetLongitude),
    );
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Le service de localisation est désactivé');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permission de localisation refusée');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Permission refusée définitivement, allez dans les paramètres',
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFF006650),
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.green,
            tabs: const [Tab(text: "Livraisons"), Tab(text: "Restaurants")],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ---------------------- Menus du jour ----------------------
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Les menus du jour",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Menus>>(
                  future: menuFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Erreur de chargement",
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          "Aucun menu disponible",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    final menus = snapshot.data!;
                    return ListView.builder(
                      itemCount: menus.length,
                      itemBuilder: (context, index) {
                        final menu = menus[index];
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            color: Colors.white38,
                            child: Column(
                              children: [
                                FutureBuilder<List<Detailsp>>(
                                  future: fetchdetsp(menu.restaurantName),
                                  builder: (context, detSnapshot) {
                                    if (!detSnapshot.hasData ||
                                        detSnapshot.data!.isEmpty) {
                                      return Container(
                                        height: 150,
                                        color: Colors.black,
                                        child: const Center(
                                          child: Text(
                                            "Pas de photo",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      );
                                    }

                                    return CarouselSlider(
                                      items:
                                          detSnapshot.data!
                                              .map(
                                                (det) => Container(
                                                  width: 150,
                                                  height: 150,
                                                  child: Image.network(
                                                    "http://demoalito.mydevcloud.com/Resto/assets/uploads/images/${det.photto}",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                      options: CarouselOptions(
                                        autoPlay: true,
                                        enlargeCenterPage: true,
                                        height: 150,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  menu.restaurantName ?? "",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Benin | ${menu.restaurantAddress}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 16),
                                    const Icon(
                                      Icons.star,
                                      color: Color(0xFF006650),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      "4.5",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (context) => Livrable(
                                                  title:
                                                      menu.restaurantName ?? "",
                                                  rstid: menu.proprio ?? "",
                                                  boxmail:
                                                      menu.restaurantEmail ??
                                                      "",
                                                ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Voir",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),

          // ---------------------- Restaurants optimisé ----------------------
          FutureBuilder<Position>(
            future: _currentPositionFuture,
            builder: (context, positionSnap) {
              if (positionSnap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (positionSnap.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Impossible de récupérer la localisation",
                        style: TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        
                        onPressed: () => Geolocator.openAppSettings(),
                        style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all(const Color(0xFF006650)),
  ),
                        child: const Text("Activer la localisation", style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                );
              }

              if (!positionSnap.hasData) {
                return const Center(
                  child: Text(
                    "Localisation indisponible",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }

              final currentPosition = positionSnap.data!;

              // ---------------------- Restaurants ----------------------
              return FutureBuilder<List<Restaurants>>(
                future: restoFuture,
                builder: (context, restoSnap) {
                  if (restoSnap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (restoSnap.hasError) {
                    return const Center(
                      child: Text(
                        "Erreur de chargement",
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (!restoSnap.hasData || restoSnap.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "Aucun restaurant disponible",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final restos = restoSnap.data!;

                  return ListView.builder(
                    itemCount: restos.length,
                    itemBuilder: (context, index) {
                      final resto = restos[index];

                      // Calcul de la distance avec la position actuelle
                      final double distanceKm = calculateDistanceFromPosition(
                        currentPosition: currentPosition,
                        targetLatitude:
                            double.tryParse(resto.restaurantLatitude ?? '') ??
                            0.0,
                        targetLongitude:
                            double.tryParse(resto.restaurantLongitude ?? '') ??
                            0.0,
                      );

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => Details(
                                      nom: resto.restaurantName ?? "",
                                      cle: resto.proprio ?? "",
                                      mail: resto.restaurantEmail ?? "",
                                    ),
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.white38,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder<List<Detail>>(
                                  future: fetchdets(resto.restaurantName),
                                  builder: (context, detSnapshot) {
                                    if (!detSnapshot.hasData ||
                                        detSnapshot.data!.isEmpty) {
                                      return Container(
                                        height: 150,
                                        color: Colors.black,
                                        child: const Center(
                                          child: Text(
                                            "Pas de photo",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return CarouselSlider(
                                      items:
                                          detSnapshot.data!
                                              .map(
                                                (det) => Container(
                                                  width: 150,
                                                  height: 150,
                                                  child: Image.network(
                                                    "http://demoalito.mydevcloud.com/Resto/assets/uploads/images/${det.photto}",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                      options: CarouselOptions(
                                        autoPlay: true,
                                        enlargeCenterPage: true,
                                        height: 150,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Text(
                                    resto.restaurantName ?? "",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    "${distanceKm.toStringAsFixed(2)} km",
                                    style: const TextStyle(color: Colors.green),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    'Benin | ${resto.restaurantAddress}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),

          /*
          // ---------------------- Restaurants ----------------------
          FutureBuilder<Position>(
            future: _currentPositionFuture,
            builder: (context, positionSnap) {
              if (positionSnap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!positionSnap.hasData) {
                return const Center(
                  child: Text(
                    "Localisation indisponible",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }

              final currentPosition = positionSnap.data!;

              // ---------------------- Restaurants ----------------------
              return FutureBuilder<List<Restaurants>>(
                future: restoFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        "Erreur de chargement",
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "Aucun restaurant disponible",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final restos = snapshot.data!;
                  return ListView.builder(
                    itemCount: restos.length,
                    itemBuilder: (context, index) {
                      final resto = restos[index];

                      final double distanceKm = calculateDistanceFromPosition(
                        currentPosition: currentPosition,
                        targetLatitude:
                            double.tryParse(resto.restaurantLatitude ?? '') ??
                            0.0,
                        targetLongitude:
                            double.tryParse(resto.restaurantLongitude ?? '') ??
                            0.0,
                      );

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => Details(
                                      nom: resto.restaurantName ?? "",
                                      cle: resto.proprio ?? "",
                                      mail: resto.restaurantEmail ?? "",
                                    ),
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.white38,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 🔁 le reste de ton UI est IDENTIQUE
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Text(
                                    resto.restaurantName ?? "",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    "${distanceKm.toStringAsFixed(2)} km",
                                    style: const TextStyle(color: Colors.green),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    'Benin | ${resto.restaurantAddress}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),*/
        ],
      ),
    );
  }
}
