import 'package:ohresto/Pages/details.dart';
import 'package:ohresto/Structures/food.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

Widget buildHintsList(List<Recipe> recipes) {
  // Fonction pour calculer la distance
  Future<double> getRestLocation(double lat, double long) async {
    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final Distance distance = Distance();
    return distance.as(
      LengthUnit.Kilometer,
      LatLng(geoposition.latitude, geoposition.longitude),
      LatLng(lat, long),
    );
  }

  return Container(
    decoration: const BoxDecoration(color: Colors.white),
    height: 470,
    child: Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          "Nos Suggestions",
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];

              final lat =
                  double.tryParse(recipe.restaurantLatitude ?? '') ?? 0.0;
              final long =
                  double.tryParse(recipe.restaurantLongitude ?? '') ?? 0.0;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Details(
                            nom: recipe.restaurantName ?? '',
                            cle: recipe.proprio ?? '',
                            mail: recipe.restaurantName?? '',),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.grey[300],
                    child: ListTile(
                      leading: Image.network(
                        "http://demoalito.mydevcloud.com/Resto//assets/uploads/images/${recipe.restaurantLogo ?? ''}",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(recipe.restaurantName ?? '',
                          style: const TextStyle(color: Colors.black)),
                      subtitle: FutureBuilder<double>(
                        future: getRestLocation(lat, long),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                                '${snapshot.data!.toStringAsFixed(2)} km',
                                style: const TextStyle(color: Colors.green));
                          }
                          return Text(
                            'Activer votre GPS',
                            style: TextStyle(color: Colors.red[400]),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
