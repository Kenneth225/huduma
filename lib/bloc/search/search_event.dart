
import 'package:equatable/equatable.dart';

// Classe de base pour les événements du SearchBloc
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

// Événement pour lancer une recherche avec une query
class Search extends SearchEvent {
  final String query;

  const Search({required this.query});

  @override
  List<Object> get props => [query];
}