import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodsan/models/food_detail_model.dart';
import 'package:foodsan/models/food_model.dart';

class ApiService {

  final String baseFoodURL = "https://www.themealdb.com/api/json/v1/1/filter.php?";
  final String baseFoodDetail = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=";

  Future<dynamic> getFoods(String filter) async {
    var dio = Dio();
    List<FoodModel> listFoods = [];
    try {
      final response = await dio.get(baseFoodURL+filter);
      Map<String, dynamic> dResponse = response.data;
      log("getFoods - url: $filter - ${dResponse['meals']}", name:"api_service");
      final jsonData = dResponse['meals'] as List;
      listFoods = jsonData.map((tagJson) => FoodModel.fromJson(tagJson)).toList();

    } on SocketException {
      throw Exception('No Internet Connection');
    }
    return listFoods;
  }

  Future<dynamic> getFoodDetail(String foodId) async {
    var dio = Dio();
    List<FoodDetailModel> listFoods = [];
    FoodDetailModel detailModel;
    try {
      final response = await dio.get(baseFoodDetail+foodId);
      Map<String, dynamic> dResponse = response.data;
      log("getFoods - url: ${baseFoodDetail+foodId} - ${dResponse['meals']}", name:"api_service");
      final jsonData = dResponse['meals'] as List;
      listFoods = jsonData.map((tagJson) => FoodDetailModel.fromJson(tagJson)).toList();
      detailModel = listFoods.first;
    } on SocketException {
      throw Exception('No Internet Connection');
    }
    return detailModel;
  }

}