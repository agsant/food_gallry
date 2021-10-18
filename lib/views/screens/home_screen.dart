
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodsan/bloc_events/food_events.dart';
import 'package:foodsan/bloc_events/foods_bloc_state.dart';
import 'package:foodsan/config/constants.dart';
import 'package:foodsan/models/food_model.dart';
import 'package:foodsan/services/api_response.dart';
import 'package:foodsan/services/api_service.dart';
import 'package:foodsan/views/screens/detail_screen.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeScreen extends StatefulWidget {

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final foodBloc;

  @override
  void initState() {
    super.initState();
    log("initState ", name:"home_sceen");
    _loadFoods();
  }

  _loadFoods() async {
    foodBloc = BlocProvider.of<FoodsBloc>(context);
    foodBloc.add(FetchAllFoods(filter: "a=Canadian"));
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      if(result != ConnectivityResult.none) {
        foodBloc.add(FetchAllFoods(filter: "a=Canadian"));
      }
    });

    Widget list(List<FoodModel> foods){
      return Scaffold(
        appBar: new AppBar(
          systemOverlayStyle:SystemUiOverlayStyle.light,
          backgroundColor: Constants.colorPrimaryDark,
          title: Align(alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Food Gallery")
              ],
            ),
          ),
        ),
        body: Container(
          color: Constants.colorPrimary,
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: foods.length,
              itemBuilder: (BuildContext context, int index){
                FoodModel food = foods[index];
                // foodBloc.add(FetchFoodDetail(foodId: food.idMeal));

                return Container(
                    child: InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BlocProvider(
                            create: (context) => FoodsBloc(apiService: ApiService()),
                            child: DetailScreen(food: food),
                          )),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        color: Constants.colorPrimaryDark,
                        elevation: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                child: FadeInImage.memoryNetwork(
                                  image: food.strMealThumb,
                                  placeholder: kTransparentImage,
                                  imageErrorBuilder: (context, url, error) => Center(child: new Text("(No Image)", style: TextStyle(color: Colors.grey),),),
                                  fit: BoxFit.fitWidth,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0, top: 4.0, right: 8.0, bottom: 4.0),
                              child: Text(
                                food.strMeal,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontFamily: 'Regular'
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                );
              }),
        ),
      );
    }

    Widget undefinedList(String error){
      return Scaffold(
          appBar: new AppBar(
            systemOverlayStyle:SystemUiOverlayStyle.light,
            backgroundColor: Constants.colorPrimaryDark,
            title: Align(alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Food Gallery")
                ],
              ),
            ),
          ),
          body: Container(
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
          )
      );
    }

    return BlocBuilder<FoodsBloc, ApiResponse>(
        builder: (BuildContext context, ApiResponse state){
          if(state is FoodsLoaded){
            return list(state.foods);
          }
          if(state is FoodsListError){
            return undefinedList(state.error);
          }

          return Container(
            color: Constants.colorPrimary,
            child: Center(child: CircularProgressIndicator()),
          );
        }
    );
  }
}