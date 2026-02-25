import 'package:equatable/equatable.dart';
import 'package:ohresto/Structures/food.dart'; // ton modèle Recipe

// Classe de base pour les états du SearchBloc
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

// État initial
class SearchUninitialized extends SearchState {}

// État de chargement
class SearchLoading extends SearchState {}

// État avec résultat
class SearchLoaded extends SearchState {
  final List<Recipe> recipes;

  const SearchLoaded({required this.recipes});

  @override
  List<Object> get props => [recipes];
}

// État d'erreur
class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});

  @override
  List<Object> get props => [message];
}