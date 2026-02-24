import 'dart:convert';
import 'package:numberpicker/numberpicker.dart';
import 'package:ohresto/Structures/avis_structure.dart';
import 'package:ohresto/config.dart';
import 'package:ohresto/controller_api/avis_api.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'fun.dart';

class Livrable extends StatefulWidget {
  final String title;
  final String rstid;
  final String boxmail;

  const Livrable({Key? key, required this.title, required this.rstid, required this.boxmail})
    : super(key: key);

  @override
  State<Livrable> createState() => _LivrableState();
}

class _LivrableState extends State<Livrable> {
  int note = 3;
  late Future<List<Avis>> avisFuture;
  late Future<List<Livrables>> repasFuture;

  List<bool> repaStatus = [];
  List<String> tmpArray = [];
  List<int> priceArray = [];
  List<int> qtArray = [];
  List<String> propriArray = [];

  bool processing = false;
  

  final TextEditingController adressectrl = TextEditingController();
  final TextEditingController cmtctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    avisFuture = fetchavis(widget.rstid);
    repasFuture = _getBouff();
  }

  // =========================
  // ====== GET REPAS ========
  // =========================
  Future<List<Livrables>> _getBouff() async {
    var url = Uri.parse("${api_link}/inforepas.php");
    var res = await http.post(url, body: {'proprio': widget.rstid});

    if (res.statusCode != 200) {
      throw Exception("Erreur lors du chargement des repas");
    }

    final List jsonData = jsonDecode(res.body);
    List<Livrables> repas = [];
    repaStatus.clear();

    for (var u in jsonData) {
      repas.add(
        Livrables(
          u["product_id"].toString(),
          u["category_name"].toString(),
          u["Type"].toString(),
          u["product_name"].toString(),
          u["product_price"].toString(),
          u["product_status"].toString(),
          u["product_image"].toString(),
          u["proprio"].toString(),
          u["isChecked"].toString(),
        ),
      );
      repaStatus.add(false);
    }

    return repas;
  }

  // =========================
  // ====== NOTER ============
  // =========================
  void noter(int valeur, BuildContext context) async {
    if (cmtctrl.text.isEmpty) {
      Fluttertoast.showToast(msg: "Entrez un commentaire");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('username') ?? "";

    var url = Uri.parse("${api_link}/addavis.php");

    var res = await http.post(
      url,
      body: {
        'proprio': widget.rstid,
        'client_name': userName,
        'note': valeur.toString(),
        'comment': cmtctrl.text,
      },
    );

    if (res.statusCode == 200) {
      _showMyDialog(context);
    } else {
      Fluttertoast.showToast(msg: "Erreur lors de l'envoi");
    }
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check_circle, color: Colors.green, size: 55),
                SizedBox(height: 10),
                Text(
                  "Votre avis a bien été envoyé",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed:
                    () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      'accueil',
                      (route) => false,
                    ),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  void _showRatingModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) {
    //  int localNote = note; // valeur locale

      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Noter ce restaurant",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: cmtctrl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Commentaire",
                    ),
                  ),
                  const SizedBox(height: 10),

                  NumberPicker(
                    value: note,
                    minValue: 1,
                    maxValue: 6,
                    step: 1,
                    onChanged: (value) {
                      setModalState(() => note = value);
                      //note = value; // si tu veux garder la valeur
                    },
                  ),

                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF006650),
                    ),
                    onPressed: () => noter(note, context),
                    child: const Text("Soumettre", style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}



  // =========================
  // ====== UI ===============
  // =========================
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(widget.title, style: TextStyle(color: Colors.white),),
          backgroundColor: const Color(0xFF006650),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.green,
            tabs: [Tab(text: "Commande"), Tab(text: "Avis")],
          ),
        ),
        body: TabBarView(
          children: [
            // ===== COMMANDE =====
            Column(
              children: [
                Expanded(
                  child: FutureBuilder<List<Livrables>>(
                    future: repasFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            snapshot.error.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      final repas = snapshot.data!;

                      return ListView.builder(
                        itemCount: repas.length,
                        itemBuilder: (context, index) {
                          final repa = repas[index];

                          return Card(
                            child: ListTile(
                              leading: Image.network(
                                "http://demoalito.mydevcloud.com/Resto/assets/uploads/images/${repa.product_image}",
                                width: 50,
                              ),
                              title: Text(repa.product_name),
                              subtitle: Text("${repa.product_price} FCFA"),
                              trailing: Checkbox(
                                  value: repaStatus[index],
                                  activeColor: Color(0xFF006650),
                                  onChanged: (bool? val) {
                                    setState(() {
                                      repaStatus[index] = val ?? false;
                                      if (repaStatus[index]) {
                                        tmpArray.add(repa.product_name);
                                        priceArray
                                            .add(int.parse(repa.product_price));
                                        qtArray.add(1);
                                        propriArray.add(repa.proprio);
                                      } else {
                                        tmpArray.remove(repa.product_name);
                                        priceArray.remove(
                                            int.parse(repa.product_price));
                                        qtArray.remove(1);
                                        propriArray.remove(repa.proprio);
                                      }
                                    });
                                  },
                                ),
                              
                           
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                
                // 🔹 BOUTON COMMANDER
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFF006650),
          minimumSize: const Size.fromHeight(50),
        ),
        onPressed: () {
          if (tmpArray.isEmpty) {
            Fluttertoast.showToast(
              msg: "Vous devez sélectionner un repas",
            );
            return;
          }

          setState(() => processing = true);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Fun(
                repas: tmpArray,
                prix: priceArray,
                qtite: qtArray,
                proprio: propriArray,
                box: widget.boxmail
              ),
            ),
          );
        },
        child: processing
            ? const CircularProgressIndicator(color: Colors.black)
            : const Text(
                "Commander",
                style: TextStyle(color: Colors.white),
              ),
      ),
    ),
              ],
            ),

            // ===== AVIS =====
            Column(
              children: [
                Expanded(
                  child: FutureBuilder<List<Avis>>(
                    future: avisFuture,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            "Aucun avis",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final avi = snapshot.data![index];
                          return Card(
                            child: ListTile(
                              title: Text("${avi.auteur}"),
                              subtitle: Text("${avi.comment}"),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: const Color(0xFF006650),
                  onPressed: () => _showRatingModal(context),
                  child: const Icon(Icons.add, color: Colors.white,),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =========================
// ===== MODEL =============
// =========================
class Livrables {
  String product_id;
  String category_name;
  String type;
  String product_name;
  String product_price;
  String product_status;
  String product_image;
  String proprio;
  String isChecked;

  Livrables(
    this.product_id,
    this.category_name,
    this.type,
    this.product_name,
    this.product_price,
    this.product_status,
    this.product_image,
    this.proprio,
    this.isChecked,
  );
}
