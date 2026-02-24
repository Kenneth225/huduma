
import 'package:ohresto/Structures/respasdet_structure.dart';
import 'package:ohresto/controller_api/repasdet_api.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'details.dart';

class Repasdet extends StatefulWidget {
  final String? alimnts;

  Repasdet({Key? key, this.alimnts}) : super(key: key);

  @override
  _RepasdetState createState() => _RepasdetState();
}

class _RepasdetState extends State<Repasdet> {
  late Future<List<Repasdets>> restoFuture;

  @override
  void initState() {
    super.initState();
    restoFuture = fetchResto(widget.alimnts);
  }

  /// Récupère la distance entre l'utilisateur et le restaurant
  Future<double> getRestLocation(double lat, double long) async {
    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final Distance distance = Distance();
    return distance.as(
        LengthUnit.Kilometer,
        LatLng(geoposition.latitude, geoposition.longitude),
        LatLng(lat, long));
  }

  /// Appelle l'API pour récupérer les restaurants
  Future<List<Repasdets>> fetchResto(String? type) async {
    if (type == null) return [];
    return await getrestos(type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF006650),
        title: Text(widget.alimnts ?? "Restaurants", style: TextStyle(color: Colors.white),),
      ),
      body: FutureBuilder<List<Repasdets>>(
        future: restoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              'Erreur lors du chargement des restaurants',
              style: TextStyle(color: Colors.red),
            ));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(
              'Aucun restaurant trouvé',
              style: TextStyle(color: Colors.white),
            ));
          } else {
            final restos = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: restos.length,
              itemBuilder: (context, index) {
                final det = restos[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Details(nom: det.restaurantName?? "", cle: det.proprio?? "", mail: det.restaurantName?? "",)));
                  },
                  child: Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Image.network(
                        "http://demoalito.mydevcloud.com/Resto/assets/uploads/images/${det.restaurantLogo}",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        det.restaurantName?? "",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: FutureBuilder<double>(
                        future: getRestLocation(
                            double.parse(det.restaurantLatitude?? ""),
                            double.parse(det.restaurantLongitude?? "")),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text("Calcul de la distance...",
                                style: TextStyle(color: Colors.white54));
                          } else if (snapshot.hasError) {
                            return Text("GPS non disponible",
                                style: TextStyle(color: Colors.red[400]));
                          } else {
                            return Text("${snapshot.data?.toStringAsFixed(2)} km",
                                style: TextStyle(color: Colors.green));
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
