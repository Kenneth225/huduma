import 'package:equatable/equatable.dart';

abstract class FoodEvent extends Equatable {}

class FetchFoodEvent extends FoodEvent {
  @override
  List<Object> get props => [];
}
