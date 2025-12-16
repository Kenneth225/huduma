
import 'package:ohresto/Structures/food.dart';
import 'package:equatable/equatable.dart';

abstract class FoodState extends Equatable {
  const FoodState();
}

class FoodInitialState extends FoodState {
  const FoodInitialState();

  @override
  List<Object> get props => [];
}

class FoodLoadingState extends FoodState {
  const FoodLoadingState();

  @override
  List<Object> get props => [];
}

class FoodLoadedState extends FoodState {
  final List<Recipe> recipes;

  const FoodLoadedState({required this.recipes});

  @override
  List<Object> get props => recipes;
}

class FoodErrorState extends FoodState {
  final String message;

  const FoodErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
