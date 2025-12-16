
import 'package:ohresto/Structures/list_recettes_structure.dart';
import 'package:ohresto/controller_api/list_recettes_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RecettesList extends StatefulWidget {
  const RecettesList({Key? key}) : super(key: key);

  @override
  _RecettesListState createState() => _RecettesListState();
}

class _RecettesListState extends State<RecettesList> {
  Future? recettesFuture;
  String? username;
  String? nbetoile;

  @override
  void initState() {
    super.initState();
    recettesFuture = recettes();
    test();
  }

  recettes() async {
    return await fetchrecettes();
  }

  void resumeModalBottomSheet(context, photo, repas, description) {
    showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Column(
              children:[ 
                SizedBox(height: 32,),
                 SingleChildScrollView(
                   child: Wrap(children: <Widget>[
                                 Container(
                    child:  Ink.image(
                          height: 100,
                          image: NetworkImage(
                            "http://demoalito.mydevcloud.com/Resto/assets/uploads/images/${photo}",
                          ),
                        ),
                                 ),
                               ]),
                 ),SingleChildScrollView(
                child: Container(
                 // height: MediaQuery.of(context).size.height,
                  margin: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Center(
                            child: Text(repas,
                                style: TextStyle(
                                    fontSize: 26.2,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic))),
                                    Center(
                      child: Text(description,
                          style: TextStyle(
                              fontSize: 14.2,
                              fontStyle: FontStyle.italic)))
                    ],
                  ),
                ),
              ),
                            
                
              
              
              ]);
        });
  }

  void test() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("username"));

    setState(() {
      username = prefs.getString("username");
      nbetoile = prefs.getString("etoile");
    });
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(251, 219, 91, 1),
        title: Text("Recettes"),
      ),
      body: SingleChildScrollView(
        child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 1.2,
                  margin: EdgeInsets.all(10.0),
                  child: FutureBuilder<dynamic>(
                    future: recettesFuture,
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          ListRecette recette = snapshot.data[index];
                          return ListTile(
                            title: Container(
                                child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Image.network(
                                      "http://demoalito.mydevcloud.com/Resto/assets/uploads/images/${recette.picture}"),
                                  title: Text(recette.nom?? "", style: TextStyle(color: Colors.white),),
                                  trailing:  int.parse(nbetoile!) >= int.parse(recette.id?? "") ? Column(
                                    children: [
                                      Icon(Icons.lock_open,color: Colors.white),
                                     // Text("${recette.id}", style: TextStyle(color: Colors.white),)
                                    ],
                                  ): Column(
                                    children: [
                                      Icon(Icons.lock, color: Colors.white),
                                     // Text("${recette.id}", style: TextStyle(color: Colors.white),)
                                    ],
                                  ) ,
                                  onTap: (){
                                    if(int.parse(nbetoile!) >= int.parse(recette.id?? "")){
                                      resumeModalBottomSheet(
                                                  context,
                                                  recette.picture,
                                                  recette.nom,
                                                  recette.explication);
                                    }else{
                                        Fluttertoast.showToast(
            msg: "Gagnez ${recette.id} Hums pour voir cette recette en commandant plus ! \n 1 Hums = 5 Commandes passées ", toastLength: Toast.LENGTH_SHORT);
                                    }
                                  } ,
                                ),
                              ],
                            )),
                          );
                        },
                      );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                
              ),
                           
                          
                          /*Text('Aucune information',
                              style: TextStyle(color: Colors.white)
                              ),*/
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
      ),    );        
            
  }
}

                                      