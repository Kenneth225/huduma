import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ohresto/bloc/food_event.dart';
import 'package:ohresto/bloc/food_state.dart';
import 'package:ohresto/controller_api/food_repository.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FoodRepository repository;

  FoodBloc({required this.repository}) : super(const FoodInitialState()) {
    on<FetchFoodEvent>((event, emit) async {
      emit(const FoodLoadingState());
      try {
        final recipes = await repository.getFoods();
        emit(FoodLoadedState(recipes: recipes));
      } catch (e) {
        emit(FoodErrorState(message: e.toString()));
      }
    });
  }
}
