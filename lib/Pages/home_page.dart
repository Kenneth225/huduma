import 'package:ohresto/Pages/details.dart';
import 'package:ohresto/Pages/list.dart';
import 'package:ohresto/Pages/loading.dart';
import 'package:ohresto/Pages/repasdet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:ohresto/bloc/food_bloc.dart';
import 'package:ohresto/bloc/food_event.dart';
import 'package:ohresto/bloc/food_state.dart';
import 'package:ohresto/bloc/search/search_bloc.dart';
import 'package:ohresto/bloc/search/search_event.dart';
import 'package:ohresto/bloc/search/search_state.dart';


// Enum pour le filtre de menu
enum MenuOption {
  Asiatique,
  Africain,
  Europeen,
  Fromage,
  Poisson,
  Viande,
  Crevette
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //late FoodBloc foodBloc;

  @override
  void initState() {
    super.initState();
   // foodBloc = BlocProvider.of<FoodBloc>(context);
   // foodBloc.add(FetchFoodEvent());
  }

  // Fonction pour calculer la distance avec latlong2
  Future<double> getRestLocation(double lat, double long) async {
    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final Distance distance = Distance();
    double rkm = distance.as(
      LengthUnit.Kilometer,
      LatLng(geoposition.latitude, geoposition.longitude),
      LatLng(lat, long),
    );
    return rkm;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(251, 219, 91, 1),
        title: Text("Rechercher un repas"),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
          /*      showSearch(
                    context: context,
                    delegate: FoodSearch(
                        searchBloc: BlocProvider.of<SearchBloc>(context)));*/
              }),
          PopupOptionMenu(),
        ],
      ),
      body: SingleChildScrollView(
        child: Text("page des blocs")
        /*BlocBuilder<FoodBloc, FoodState>(
          builder: (context, state) {
            if (state is FoodInitialState || state is FoodLoadingState) {
              return buildLoading();
            } else if (state is FoodLoadedState) {
              return buildHintsList(state.recipes);
            } else if (state is FoodErrorState) {
              return Center(
                  child: Text(
                "Erreur de chargement",
                style: TextStyle(color: Colors.red),
              ));
            }
            return buildLoading();
          },
        ),*/
      ),
    );
  }
}
/*
// SearchDelegate corrigé
class FoodSearch extends SearchDelegate<List> {
  final SearchBloc searchBloc;
  FoodSearch({required this.searchBloc});

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

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          //close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    searchBloc.add(Search(query: query));
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchUninitialized) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SearchError) {
          return Center(child: Text('Pas de résultat pour le moment'));
        } else if (state is SearchLoaded) {
          if (state.recipes.isEmpty) {
            return Center(child: Text("Pas de résultat pour le moment"));
          }
          return ListView.builder(
              itemCount: state.recipes?.length,
              itemBuilder: (context, index) {
                final recipe = state.recipes?[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => Details(
                                nom: recipe.restaurantName,
                                cle: recipe.proprio)));
                  },
                  child: ListTile(
                    leading: Image.network(
                        "http://demoalito.mydevcloud.com/Resto/assets/uploads/images/${recipe.restaurantLogo}"),
                    title: Text(recipe.restaurantName,
                        style: TextStyle(color: Colors.white)),
                    subtitle: FutureBuilder<double>(
                      future: getRestLocation(
                        double.parse(recipe.restaurantLatitude),
                        double.parse(recipe.restaurantLongitude),
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text('${snapshot.data!.toStringAsFixed(2)} km',
                              style: TextStyle(color: Colors.green));
                        }
                        return Text('Activer votre GPS',
                            style: TextStyle(color: Colors.red[400]));
                      },
                    ),
                  ),
                );
              });
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(); // On peut ajouter des suggestions dynamiques si besoin
  }
}*/

// PopupMenu corrigé
class PopupOptionMenu extends StatelessWidget {
  const PopupOptionMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuOption>(
      itemBuilder: (context) => <PopupMenuEntry<MenuOption>>[
        PopupMenuItem(child: Text("Plat Africain"), value: MenuOption.Africain),
        PopupMenuItem(child: Text("Plat Asiatique"), value: MenuOption.Asiatique),
        PopupMenuItem(child: Text("Plat Européen"), value: MenuOption.Europeen),
        PopupMenuItem(child: Text("Fromage/Wangachi"), value: MenuOption.Fromage),
        PopupMenuItem(child: Text("Poisson"), value: MenuOption.Poisson),
        PopupMenuItem(child: Text("Viande"), value: MenuOption.Viande),
        PopupMenuItem(child: Text("Crevette"), value: MenuOption.Crevette),
      ],
      onSelected: (value) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  Repasdet(alimnts: value.toString().substring(11))),
        );
      },
    );
  }
}
