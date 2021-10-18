
import 'dart:developer';
import 'dart:ui';

import 'package:basic_utils/basic_utils.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodsan/bloc_events/food_events.dart';
import 'package:foodsan/bloc_events/foods_bloc_state.dart';
import 'package:foodsan/config/constants.dart';
import 'package:foodsan/models/food_detail_model.dart';
import 'package:foodsan/models/food_model.dart';
import 'package:foodsan/services/api_response.dart';
import 'package:transparent_image/transparent_image.dart';

class DetailScreen extends StatefulWidget {
  FoodModel food;

  DetailScreen({Key? key, required this.food}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState(food: food);
}

class _DetailScreenState extends State<DetailScreen> {

  FoodModel food;
  late final foodBloc;
  _DetailScreenState({required this.food});

  @override
  void initState() {
    super.initState();
    _loadFood();
  }

  _loadFood() async {
    foodBloc = BlocProvider.of<FoodsBloc>(context);
    foodBloc.add(FetchFoodDetail(foodId: food.idMeal));
  }

  @override
  Widget build(BuildContext context) {

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      if(result != ConnectivityResult.none) {
        foodBloc.add(FetchFoodDetail(foodId: food.idMeal));
      }
    });

    Widget foodDetail(FoodDetailModel foodModel){
      return Container(
        padding: EdgeInsets.all(10),
        color: Constants.colorPrimary,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 240,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Title: ${foodModel.strMeal}", style: TextStyle(fontSize: 16, color: Constants.colorWhite),),
                      Text("Category: ${foodModel.strCategory}", style: TextStyle(fontSize: 14, color: Constants.colorWhite),),
                      Text("Area: ${foodModel.strArea}", style: TextStyle(fontSize: 14, color: Constants.colorWhite),),
                      Text("Tags: ${foodModel.strTags}", style: TextStyle(fontSize: 14, color: Constants.colorWhite))
                    ],
                  ),
                ),
                FadeInImage.memoryNetwork(
                  image: food.strMealThumb,
                  placeholder: kTransparentImage,
                  imageErrorBuilder: (context, url, error) => Center(child: new Text("(No Image)", style: TextStyle(color: Colors.grey),),),
                  fit: BoxFit.fitWidth,
                  width: 140,
                ),
              ],
            ),
            new Container(
              margin: EdgeInsets.only(top: 12),
              child: Text("Instruction: ${foodModel.strInstructions}", style: TextStyle(fontSize: 14, color: Constants.colorWhite),),
            ),
            new Container(
              margin: EdgeInsets.only(top: 24),
              child: Text("Source: ${foodModel.strSource}", style: TextStyle(fontSize: 14, color: Constants.colorWhite),),
            )

          ],
        )
      );
    }

    Widget undefinedDetail(String error){
      return Container(
        color: Constants.colorPrimary,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: 140.0,
              ),
              Text("Error", style: TextStyle(color: Constants.colorWhite, fontSize: 28, fontWeight: FontWeight.bold),),
              Text(error, style: TextStyle(color: Constants.colorWhite, fontSize: 20),),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 30,
                  width: 150,
                  child: TextButton(
                      onPressed: (){
                        // Provider.of<HeroViewModel>(context, listen: false).fetchAllHeroes();
                      },
                      child: Text("Retry", style: TextStyle(color: Constants.colorWhite),),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Constants.colorPrimaryDark),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )
                          )
                      )
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
        appBar: new AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Constants.colorPrimaryDark,
          title: Align(alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min,
              children: [
                Text(food.strMeal)
              ],
            ),
          ),
        ),
        body: BlocBuilder<FoodsBloc, ApiResponse>(
            builder: (BuildContext context, ApiResponse state){
              log("state builder: $state", name:"detail_screen");
              if(state is FoodDetailLoaded){
                return foodDetail(state.food);
              }
              if(state is FoodsListError){
                return undefinedDetail(state.error);
              }

              return Container(
                color: Constants.colorPrimary,
                child: Center(child: CircularProgressIndicator()),
                );
            }
        )
    );
  }
}
