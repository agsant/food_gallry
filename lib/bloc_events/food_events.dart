
abstract class FoodEvents {}

class FetchAllFoods extends FoodEvents {
  String filter;
  FetchAllFoods({required this.filter});
}

class FetchFoodDetail extends FoodEvents {
  String foodId;
  FetchFoodDetail({required this.foodId});
}