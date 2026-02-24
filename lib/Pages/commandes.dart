import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ohresto/Structures/commande_structure.dart';
import 'package:ohresto/Structures/orderitem_structure.dart';
import 'package:ohresto/Structures/reservation_structure.dart';
import 'package:ohresto/config.dart';
import 'package:ohresto/controller_api/commande_api.dart';
import 'package:ohresto/controller_api/orderitem_api.dart';
import 'package:ohresto/controller_api/reservation_api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Commandes extends StatefulWidget {
  const Commandes({Key? key}) : super(key: key);

  @override
  _CommandesState createState() => _CommandesState();
}

class _CommandesState extends State<Commandes>
    with SingleTickerProviderStateMixin {
  late Future<List<Orders>> commandeFuture;
  late Future<List<Reservation>> reserveFuture;
  late TabController _tabController;
  late TextEditingController codectrl;
  String qrResult = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    codectrl = TextEditingController();
    commandeFuture = fetchorders();
    reserveFuture = fetchmyreserv();
  }

  @override
  void dispose() {
    _tabController.dispose();
    codectrl.dispose();
    super.dispose();
  }

  Color getColor(String? status) {
    switch (status) {
      case "En attente":
        return Colors.grey;
      case "Rejeter":
        return Colors.red;
      case "En cours de preparation":
        return Colors.orangeAccent;
      case "En cour de livraison":
      case "Valider":
        return Colors.blue;
      case "Livraison Effectué":
      case "Effectuer":
        return Colors.green;
      default:
        return Colors.white;
    }
  }

  Future<List<Odets>> info(String iduniq) async {
    return await viewdets(iduniq);
  }

  Future<void> _showdetailfood(BuildContext context, iduniq) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Détails"),
        content: SizedBox(
          width: double.maxFinite,
          height: 150, // 👈 HAUTEUR OBLIGATOIRE
          child: FutureBuilder<List<Odets>>(
            future: info(iduniq),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Aucun détail disponible."));
              }

              final data = snapshot.data!;

              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final det = data[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('${det.repas} × ${det.quantite}'),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    },
  );
}


  /*Future<void> _showdetailfood(context, iduniq) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: FutureBuilder<List<Odets>>(
            future: info(iduniq),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
          
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text("Aucun détail disponible.");
              }
          
              final data = snapshot.data!;
          
              return ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final det = data[index];
                  return Text('${det.repas} * ${det.quantite}');
                },
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }*/

  Future<void> _showmodal(context, iduniq) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            "Le Livreur est passé",
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              child: const Text('NON'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('OUI'),
              onPressed: () {
                valider(iduniq);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> reloadList() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      commandeFuture = fetchorders();
    });
  }

  Future<void> chargedList() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      reserveFuture = fetchmyreserv();
    });
  }

  // 🔹 Fonction pour scanner QR avec mobile_scanner
  Future<void> scanQr(
      BuildContext context,
      String proprio,
      String clientName,
      String orderId,
      String orderStatus,
      Function(String) onValid) async {
    if (orderStatus != "En cour de livraison" && orderStatus != "Valider") return;

    final String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const QrScanPage(),
      ),
    );

    if (result == null) return;

    setState(() {
      qrResult = result;
    });

    if (qrResult == "_'$proprio'_'$clientName'") {
      onValid(orderId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar:AppBar(
        foregroundColor: Colors.white,
  title: const Text('Mes Commandes', style: TextStyle(color: Colors.white)),
  backgroundColor: const Color(0xFF006650),
  bottom: TabBar(
    controller: _tabController,
    labelColor: Colors.white,
    unselectedLabelColor: Colors.white54,
    indicatorColor: Colors.green,
    tabs: const [
      Tab(text: "Vos Commandes"),
      Tab(text: "Vos Réservations"),
    ],
  ),
),
      body: TabBarView(
        controller: _tabController,
        children: [_buildCommandesView(), _buildReservationsView()],
      ),
    );
  }

  Widget _buildCommandesView() {
    return RefreshIndicator(
      onRefresh: reloadList,
      child: FutureBuilder<List<Orders>>(
        future: commandeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Aucune Commande",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final com = data[index];

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.fastfood_outlined),
                        title: Text('${com.repas} ...'),
                        subtitle: Text('${com.amount}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_red_eye_outlined),
                          onPressed: () =>
                              _showdetailfood(context, com.orderIdUniq),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 🔹 NumberPicker intégré pour Qtité
                        /*  NumberPicker(
                            value:  1,
                            minValue: 1,
                            maxValue: 10,
                            step: 1,
                            itemHeight: 40,
                            onChanged: (val) {
                              setState(() {
                                com.quantite = val as String?;
                              });
                            },
                          ),
                          const SizedBox(width: 10),*/
                          TextButton(
                            child: Text(
                              '${com.orderStatus}',
                              style: TextStyle(
                                color: getColor(com.orderStatus),
                              ),
                            ),
                            onPressed: () async {
                              await scanQr(context, '${com.proprio}', '${com.clientName}',
                                  '${com.orderId}', '${com.orderStatus}', valider_com);
                            },
                          ),
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
    );
  }

  Widget _buildReservationsView() {
    return RefreshIndicator(
      onRefresh: chargedList,
      child: FutureBuilder<List<Reservation>>(
        future: reserveFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Aucune Réservation",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final com = data[index];

              return Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.family_restroom),
                      title: Text('Lieu: ${com.restaurantName}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date: ${com.orderDate}'),
                          Text('Heure: ${com.orderTime}'),
                          Text('Nombre de places: ${com.orderNbPlace}'),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      /*  NumberPicker(
                          value: 1 ,
                          minValue: 1,
                          maxValue: 20,
                          step: 1,
                          itemHeight: 40,
                          onChanged: (val) {
                            setState(() {
                              com.orderNbPlace = val as String?;
                            });
                          },
                        ),*/
                        const SizedBox(width: 10),
                        TextButton(
                          child: Text(
                            '${com.orderStatus}',
                            style: TextStyle(
                              color: getColor(com.orderStatus),
                            ),
                          ),
                          onPressed: () async {
                            await scanQr(
                                context,
                                '${com.proprio}',
                                '${com.clientName}',
                                '${com.orderNbPlace}',
                                '${com.orderStatus}', (id) {
                              valider_reserv(
                                  com.proprio, com.orderDate, com.orderNbPlace);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void valider(String iduniq) async {
    final url =
        Uri.parse("${api_link}/updatecom.php");
    final res = await http.post(url, body: {'code': iduniq});
    if (res.body.isNotEmpty) {
      print(jsonDecode(res.body));
    }
  }

  void valider_reserv(iduniq, jour, tinmin) async {
    final url =
        Uri.parse("${api_link}/updatereserv.php");
    final res = await http.post(url, body: {'code': iduniq, 'place': tinmin});
    if (res.body.isNotEmpty) {
      print(jsonDecode(res.body));
    }
  }

  void valider_com(iduniq) async {
    final url = Uri.parse("${api_link}/validcom.php");
    final res = await http.post(url, body: {'code': iduniq});
    if (res.body.isNotEmpty) {
      print(jsonDecode(res.body));
    }
  }
}

// 🔹 Page scanner QR avec mobile_scanner
class QrScanPage extends StatelessWidget {
  const QrScanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner le QR code')),
      body: MobileScanner(
        //allowDuplicates: false,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? code = barcodes.first.rawValue;
            if (code != null) {
              Navigator.pop(context, code);
            }
          }
        },
      ),
    );
  }
}
