import 'package:numberpicker/numberpicker.dart';
import 'package:ohresto/Structures/details_structure.dart';
import 'package:ohresto/config.dart';
import 'package:ohresto/controller_api/details_api.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'livrable.dart';

class Details extends StatefulWidget {
  final String nom;
  final String cle;
  final String mail;

  const Details({Key? key, required this.nom, required this.cle, required this.mail})
    : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late Future<List<Detail>> informationFuture;

  DateTime? when;
  TimeOfDay? hour;
  int place = 1;

  @override
  void initState() {
    super.initState();
    informationFuture = fetchInfo();
  }

  Future<List<Detail>> fetchInfo() async {
    final result = await fetchdets(widget.nom);
    return result.cast<Detail>();
  }

  Future<void> validation(
    DateTime day,
    TimeOfDay time,
    int place,
    String proprio,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? userName = prefs.getString('username') ?? '';

    var url = Uri.parse("${api_link}/reservation.php");
    var data = {
      'proprio': proprio,
      'client_name': userName,
      'order_date': day.toIso8601String(),
      'order_time': "${time.hour}:${time.minute}",
      'nbplace': place.toString(),
    };

    var res = await http.post(url, body: data);
    if (res.body.isNotEmpty) {
      jsonDecode(res.body);
      _showConfirmationDialog();
    } else {
      Fluttertoast.showToast(msg: "Erreur lors de la réservation");
    }
  }

  Future<TimeOfDay?> _selectTime(BuildContext context) {
    final now = TimeOfDay.now();
    return showTimePicker(context: context, initialTime: now);
  }

  Future<DateTime?> _selectDate(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
  }

  void _showConfirmationDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check_circle_rounded, color: Colors.green, size: 55),
                SizedBox(height: 10),
                Text("Réservation effectuée", style: TextStyle(fontSize: 23)),
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
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _openReservationModal() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          "Quand souhaitez-vous aller au restaurant ?",
                          style: TextStyle(fontSize: 25),
                        ),
                        ListTile(
                          title: const Text("Date et Heure"),
                          subtitle:
                              when == null || hour == null
                                  ? TextButton.icon(
                                    onPressed: () async {
                                      final selectedDate = await _selectDate(
                                        context,
                                      );
                                      if (selectedDate == null) return;
                                      final selectedTime = await _selectTime(
                                        context,
                                      );
                                      if (selectedTime == null) return;

                                      setStateModal(() {
                                        when = selectedDate;
                                        hour = selectedTime;
                                      });
                                    },
                                    icon: const Icon(Icons.access_alarm),
                                    label: const Text(
                                      "Sélectionner date et heure",
                                    ),
                                  )
                                  : Text(
                                    "${when!.toLocal().toString().split(' ')[0]} || ${hour!.format(context)}",
                                  ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              "Nombre de personnes: ",
                              style: TextStyle(fontSize: 17),
                            ),
                            NumberPicker(
                              value: place,
                              minValue: 1,
                              maxValue: 10,
                              step: 1,
                              onChanged: (int value) {
                                setStateModal(() {
                                  place = value;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF006650)
                          ),
                          child: const Text("APPLIQUER", style: TextStyle(color: Colors.white),),
                          onPressed: () {
                            if (when == null || hour == null) {
                              Fluttertoast.showToast(
                                msg: "Veuillez insérer la date et l'heure",
                              );
                            } else {
                              validation(when!, hour!, place, widget.cle);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(widget.nom, style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF006650),
      ),
      body: FutureBuilder<List<Detail>>(
        future: informationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Aucune information disponible",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final details = snapshot.data!;
          return ListView(
            children: [
              SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: details.length,
                  itemBuilder: (context, index) {
                    final det = details[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        "http://demoalito.mydevcloud.com/Resto/assets/uploads/images/${det.photto}",
                      ),
                    );
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.fastfood),
                title: const Text(
                  "Nos Repas",
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => Livrable(title: widget.nom, rstid: widget.cle, boxmail: widget.mail,),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_circle_rounded),
                title: const Text(
                  "Réservation",
                  style: TextStyle(color: Colors.black),
                ),
                onTap: _openReservationModal,
              ),
              ListTile(
                leading: const Icon(Icons.map),
                title: const Text(
                  "Adresse",
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  final det = details[0];
                  showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          title: Text(det.restaurantAddress),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Latitude: ${det.restaurantLatitude}"),
                              Text("Longitude: ${det.restaurantLongitude}"),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Fermer"),
                            ),
                          ],
                        ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
