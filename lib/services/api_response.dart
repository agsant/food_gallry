
import 'package:equatable/equatable.dart';
import 'package:foodsan/models/food_detail_model.dart';
import 'package:foodsan/models/food_model.dart';

abstract class ApiResponse extends Equatable {

  @override
  List<Object> get props => [];

}

class FoodsInitState extends ApiResponse {}
class FoodsLoading extends ApiResponse {}
class FoodsLoaded extends ApiResponse {
  late final List<FoodModel> foods;
  FoodsLoaded({required this.foods});
}
class FoodDetailLoaded extends ApiResponse {
  late FoodDetailModel food;
  FoodDetailLoaded({required this.food});
}

class FoodsListError extends ApiResponse{
  final error;
  FoodsListError({this.error});
}

