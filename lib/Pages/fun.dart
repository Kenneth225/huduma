import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Fun extends StatefulWidget {
  final List<dynamic> repas;
  final List<dynamic> prix;
  final List<dynamic> qtite;
  final List<dynamic> proprio;

  Fun({Key? key, required this.repas, required this.prix, required this.qtite, required this.proprio})
      : super(key: key);

  @override
  _FunState createState() => _FunState();
}

class _FunState extends State<Fun> {
  late TextEditingController adressectrl;
  late TextEditingController numberctrl;
  List tmpArray = [];
  List priceArray = [];
  bool processing = false;
  bool map = false;
  double montant = 0;
  String local_longitude = "0.00";
  String local_latitude = "0.00";

  @override
  void initState() {
    super.initState();
    adressectrl = TextEditingController();
    numberctrl = TextEditingController();
  }

  Future<void> getCurrentLocation() async {
    setState(() {
      map = true;
    });
    final geoposition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      local_latitude = '${geoposition.latitude}';
      local_longitude = '${geoposition.longitude}';
    });
  }

  void validation(List repas, List quantite, double montant, List proprio) async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('id');
    final String? userName = prefs.getString('username');

    var url = Uri.parse("http://demoalito.mydevcloud.com/api/commande.php");
    var data = {
      'user': userId ?? '',
      'proprio': proprio.isNotEmpty ? proprio[0] : '',
      'client_name': userName ?? '',
      'amount': montant.toString(),
      'order_adresse': adressectrl.text,
      'long': local_longitude,
      'lat': local_latitude,
      'number_client': numberctrl.text,
      'bouf': repas.toString(),
      'quant': quantite.toString(),
    };

    setState(() {
      processing = true;
    });

    var res = await http.post(url, body: data);
    tmpArray.clear();
    priceArray.clear();
    if (res.body.isNotEmpty) {
      jsonDecode(res.body);
      _settingModalBottomSheet(context);
    } else {
      Fluttertoast.showToast(msg: "Echec de la commande", toastLength: Toast.LENGTH_SHORT);
    }

    setState(() {
      processing = false;
    });
  }

  void calcul() {
    montant = 0;
    for (int i = 0; i < widget.repas.length; i++) {
      montant += (widget.prix[i] * widget.qtite[i]);
    }
  }

  void resumeModalBottomSheet(BuildContext context, List repas, List quantite, List prixu, List prprio, double mnt) {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Center(
                child: Text("Ticket Commande",
                    style: TextStyle(fontSize: 26.2, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))),
            Column(
              children: [
                const Center(child: Text("ITEMS", style: TextStyle(fontSize: 20.2, fontStyle: FontStyle.italic))),
                Card(
                  child: ListView.builder(
                    itemCount: repas.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text('${repas[index]}', style: const TextStyle(fontSize: 17.2, fontWeight: FontWeight.bold)),
                                      const Text(" X "),
                                      Text('${quantite[index]}', style: const TextStyle(fontSize: 17.2, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Text('Prix U: ${prixu[index]}',
                                      style: const TextStyle(fontSize: 17.2, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text("Sous Total : ", style: TextStyle(fontSize: 17.2, fontWeight: FontWeight.bold)),
                          Text("${mnt.toString()} CFA", style: TextStyle(fontSize: 17.2, color: Colors.green[200])),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Taxe : ", style: TextStyle(fontSize: 17.2, fontWeight: FontWeight.bold)),
                          Text("0 CFA", style: TextStyle(fontSize: 17.2, color: Colors.green[200])),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Total à Payer : ", style: TextStyle(fontSize: 17.2, fontWeight: FontWeight.bold)),
                          Text("${mnt.toString()} CFA", style: TextStyle(fontSize: 17.2, color: Colors.green[200])),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006650)),
                onPressed: () {
                  validation(repas, quantite, mnt, prprio);
                },
                child: processing
                    ? const CircularProgressIndicator(color: Colors.red)
                    : const Text("Effectuer Commande"),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Sommaire de commande"),
        backgroundColor: const Color(0xFF006650),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(17.0),
              child: Card(
                child: ListView.builder(
                  itemCount: widget.repas.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final nomrepas = widget.repas[index];
                    return ListTile(
                      title: Text('$nomrepas'),
                      subtitle: Column(
                        children: [
                          const Text("Quantité"),
                          Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    // ➖ Bouton -
    OutlinedButton(
      style: OutlinedButton.styleFrom(shape: const CircleBorder()),
      onPressed: widget.qtite[index] > 1
          ? () {
              setState(() {
                widget.qtite[index] -= 1;
                calcul();
              });
            }
          : null,
      child: const Text("-"),
    ),

    // 🔢 NumberPicker
    NumberPicker(
      value: widget.qtite[index],
      minValue: 1,
      maxValue: 10,
      step: 1,
      itemWidth: 50,
      itemHeight: 40,
      onChanged: (value) {
        setState(() {
          widget.qtite[index] = value;
          calcul();
        });
      },
    ),

    // ➕ Bouton +
    OutlinedButton(
      style: OutlinedButton.styleFrom(shape: const CircleBorder()),
      onPressed: widget.qtite[index] < 10
          ? () {
              setState(() {
                widget.qtite[index] += 1;
                calcul();
              });
            }
          : null,
      child: const Text("+"),
    ),
  ],
),

                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            _buildContactCard(),
            const SizedBox(height: 15),
            _buildAdresseCard(),
            const SizedBox(height: 15),
            _buildPaiementCard(),
            const SizedBox(height: 15),
            _buildConfirmButton(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.phone),
          title: const Text('Contact'),
          subtitle: TextField(
            
            keyboardType: TextInputType.phone,
            maxLength: 8,
            controller: numberctrl,
            decoration: const InputDecoration.collapsed(hintText: ""),
          ),
        ),
      ),
    );
  }

  Widget _buildAdresseCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.location_pin),
              title: const Text('Adresse'),
              subtitle: TextField(
                controller: adressectrl,
                maxLines: null,
                keyboardType: TextInputType.streetAddress,
                decoration: const InputDecoration.collapsed(hintText: "Indiquez votre adresse"),
              ),
            ),
            map
                ? const Text("Position récupérée", style: TextStyle(color: Colors.green, fontStyle: FontStyle.italic))
                : ElevatedButton(
                    onPressed: getCurrentLocation,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006650)),
                    child: const Text("Envoyer ma position actuelle"),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaiementCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.money),
          title: const Text('Moyen de paiement'),
          subtitle: const Text('Paiement Cash', style: TextStyle(color: Colors.green)),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(colors: [Color(0xFF006650), Color(0xFF006650)]),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006650)),
        onPressed: () {
          if (numberctrl.text.isEmpty) {
            Fluttertoast.showToast(msg: "Veillez remplir tous les champs", toastLength: Toast.LENGTH_SHORT);
          } else if (!map && adressectrl.text.isEmpty) {
            Fluttertoast.showToast(msg: "Veillez indiquer une adresse", toastLength: Toast.LENGTH_SHORT);
          } else {
            calcul();
            resumeModalBottomSheet(context, widget.repas, widget.qtite, widget.prix, widget.proprio, montant);
          }
        },
        child: processing ? const CircularProgressIndicator(color: Colors.red) : const Text("Confirmer Commande"),
      ),
    );
  }
}

void _settingModalBottomSheet(BuildContext context) {
  showModalBottomSheet(
    isDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Wrap(
        children: [
          const Center(child: Icon(Icons.check_circle_rounded, color: Colors.green, size: 55.0)),
          const Center(child: Text("Commande Envoyée", style: TextStyle(fontSize: 23.2))),
          const Center(child: Text("Votre commande devrait être prise en compte d'ici 5 min", style: TextStyle(fontSize: 23.2))),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006650)),
              child: const Text("Terminer"),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, 'accueil', (route) => false);
              },
            ),
          ),
        ],
      );
    },
  );
}
