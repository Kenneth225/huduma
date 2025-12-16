import 'package:equatable/equatable.dart';

// Classe abstraite des événements Search
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

// Evénement pour lancer une recherche
class Search extends SearchEvent {
  final String query; // non-nullable et final

  const Search({required this.query});

  @override
  List<Object> get props => [query];
}
