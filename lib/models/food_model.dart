class FoodModel {
  late String strMeal;
  late String strMealThumb;
  late String idMeal;

  FoodModel({required this.strMeal, required this.strMealThumb, required this.idMeal});

  FoodModel.fromJson(Map<String, dynamic> json) {
    strMeal = json['strMeal'];
    strMealThumb = json['strMealThumb'];
    idMeal = json['idMeal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['strMeal'] = this.strMeal;
    data['strMealThumb'] = this.strMealThumb;
    data['idMeal'] = this.idMeal;
    return data;
  }
}