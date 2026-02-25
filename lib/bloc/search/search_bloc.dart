import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ohresto/controller_api/search_repository.dart';
import 'search_event.dart';
import 'search_state.dart'; 
import 'package:ohresto/Structures/food.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repository;

  SearchBloc({required this.repository}) : super(SearchUninitialized()) {
    on<Search>((event, emit) async {
      emit(SearchLoading());
      try {
        // Appel au repository pour récupérer les recettes
        final List<Recipe> recipes = await repository.searchFoods(event.query);
        emit(SearchLoaded(recipes: recipes));
      } catch (e) {
        emit(SearchError(message: e.toString()));
      }
    });
  }
}