
import 'package:ohresto/Pages/repasdet.dart';
import 'package:ohresto/Pages/typefood.dart';
import 'package:ohresto/controller_api/search_api.dart';
import 'package:flutter/material.dart';


class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late Future<List<FoodItem>> loadFuture;

  @override
  void initState() {
    super.initState();
    loadFuture = loadfood() as Future<List<FoodItem>>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromRGBO(143, 148, 251, 1),
          title: Text("Rechercher un repas", style: TextStyle(color: Colors.white),),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: FoodItemsSearch(loadFuture: loadFuture),
                );
              },
              icon: Icon(Icons.search, color: Colors.white,),
            ),
            PopupOptionMenu(),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 50, color: Colors.white54),
            SizedBox(height: 10),
            Text(
              "Aucun restaurant à afficher",
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

enum MenuOption { Km, Asiatique, Fromage, Poisson, Viande, Crevette }

class PopupOptionMenu extends StatelessWidget {
  const PopupOptionMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuOption>(
      icon: Icon(Icons.filter_list),
      onSelected: (MenuOption value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Repasdet(alimnts: value.toString().split('.').last),
          ),
        );
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuOption>>[
        PopupMenuItem(child: Text("A 1 km"), value: MenuOption.Km),
        PopupMenuItem(child: Text("Plat Asiatique"), value: MenuOption.Asiatique),
        PopupMenuItem(child: Text("Fromage"), value: MenuOption.Fromage),
        PopupMenuItem(child: Text("Poisson"), value: MenuOption.Poisson),
        PopupMenuItem(child: Text("Viande"), value: MenuOption.Viande),
        PopupMenuItem(child: Text("Crevette"), value: MenuOption.Crevette),
      ],
    );
  }
}

class FoodItemsSearch extends SearchDelegate<FoodItem> {
  final Future<List<FoodItem>> loadFuture;

  FoodItemsSearch({required this.loadFuture});

  Future<List<FoodItem>> fetchFoods(String query) async {
    final allFoods = await loadFuture;
    if (query.isEmpty) return allFoods;
    return allFoods
        .where((f) => f.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = "",
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        
      }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<FoodItem>>(
      future: fetchFoods(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text("Erreur lors de la recherche",
                  style: TextStyle(color: Colors.red)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("Aucun résultat"));
        } else {
          final results = snapshot.data!;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final item = results[index];
              return ListTile(
                title: Text("${item.title}", style: TextStyle(color: Colors.black)),
                onTap: () {
                  // Action à la sélection, par exemple ouvrir Repasdet
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Repasdet(alimnts: item.title),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Text("Tapez pour rechercher", style: TextStyle(color: Colors.white54)),
      );
    }

    return FutureBuilder<List<FoodItem>>(
      future: fetchFoods(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text("Erreur lors de la recherche",
                  style: TextStyle(color: Colors.red)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("Aucun résultat"));
        } else {
          final suggestions = snapshot.data!;
          return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final item = suggestions[index];
              return ListTile(
                title:
                    Text("${item.title}", style: TextStyle(color: Colors.black)),
                onTap: () {
                  query = item.title!;
                  showResults(context);
                },
              );
            },
          );
        }
      },
    );
  }
}
