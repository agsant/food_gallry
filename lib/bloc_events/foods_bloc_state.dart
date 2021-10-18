
import 'dart:developer';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodsan/bloc_events/food_events.dart';
import 'package:foodsan/models/food_detail_model.dart';
import 'package:foodsan/models/food_model.dart';
import 'package:foodsan/services/api_response.dart';
import 'package:foodsan/services/api_service.dart';

class FoodsBloc extends Bloc<FoodEvents, ApiResponse>{

  final ApiService apiService;

  List<FoodModel> foods = [];
  late FoodDetailModel foodDetail;

  FoodsBloc({required this.apiService}) : super(FoodsInitState());

  Stream<ApiResponse> mapEventToState(FoodEvents event) async* {

    if(event is FetchAllFoods){
      yield FoodsLoading();
      try {
        log("mapEventToState ${event.filter}", name:"food_bloc");
        log("mapEventToState ${apiService.getFoods(event.filter)}", name:"food_bloc");
        foods = await apiService.getFoods(event.filter);
        yield FoodsLoaded(foods: foods);
      } on SocketException {
        yield FoodsListError(
          error: "No Internet Connection",
        );
      } on HttpException {
        yield FoodsListError(
          error: "No Service Found",
        );
      } on FormatException {
        yield FoodsListError(
          error: "Invalid Response format",
        );
      } catch (e) {
        yield FoodsListError(
          error: "Unknown Error",
        );
      }
    }else if(event is FetchFoodDetail){
      yield FoodsLoading();
      try {
        foodDetail = await apiService.getFoodDetail(event.foodId);
        yield FoodDetailLoaded(food: foodDetail);
      } on SocketException {
        yield FoodsListError(
          error: "No Internet Connection",
        );
      } on HttpException {
        yield FoodsListError(
          error: "No Service Found",
        );
      } on FormatException {
        yield FoodsListError(
          error: "Invalid Response format",
        );
      } catch (e) {
        yield FoodsListError(
          error: "Unknown Error",
        );
      }
    }
  }
}