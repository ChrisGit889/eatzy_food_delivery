import 'package:eatzy_food_delivery/utils/utils_seller.dart';
import 'package:flutter/material.dart';
import 'package:eatzy_food_delivery/data/dummy/dummy_data.dart';

String numToRupiah(number) {
  var temp = number.toString();
  for (var i = 3; i < temp.length; i += 4) {
    temp =
        "${temp.substring(0, temp.length - i)}.${temp.substring(temp.length - i, temp.length)}";
  }
  return "Rp.$temp,00";
}

String numToDollar(number) {
  var num = number.toStringAsFixed(2).toString().replaceAll(".", ",");
  var res = num.substring(num.length - 3, num.length);
  var temp = num.substring(0, num.length - 3);
  for (var i = 3; i < temp.length; i += 4) {
    temp =
        "${temp.substring(0, temp.length - i)}.${temp.substring(temp.length - i, temp.length)}";
  }
  return "\$$temp$res";
}

Widget imageOfCategory(category, width, height) {
  return wrapImage(imagePathOfCategory(category), width, height);
}

String imagePathOfCategory(category) {
  switch (category) {
    case "pizza":
      {
        return "assets/images/Pizza.png";
      }
    case "burger":
      {
        return "assets/images/Burger.png";
      }
    case "snacks":
      {
        return "assets/images/Snacks.png";
      }
    case "drinks":
    case "drink":
      {
        return "assets/images/Water.png";
      }
    default:
      {
        return "assets/images/placeholder.png";
      }
  }
}

Widget wrapImage(path, width, height) {
  return Image.asset(path, height: height, width: width);
}

Future<void> cleanAndRemigrate() async {
  try {
    //make restaurants in database from dummy
    var i = 0;
    for (var seller in DummyData.popularRestaurants) {
      i += 1;
      await makeSellerFromInfo(
        email: "dummy$i@gmail.com",
        address: seller["address"],
        image: seller["imagePath"],
        storeName: seller["name"],
      );
    }

    //make items for rests
    for (var category in DummyData.categories) {
      var categoryName = category["name"].toString().toLowerCase();
      for (var food in category["foods"]) {
        var storeName = food["restaurant"];
        print(storeName);
        var email = (await getSellerDataFromName(name: storeName))!["email"];
        if (await makeNewSellerItemForStore(
          email: email,
          name: food["name"] as String,
          desc: food["description"] as String,
          price: food["price"],
          type: categoryName,
          rating: double.parse(food["rating"].toString()),
          reviews: double.parse(food["reviews"].toString()),
        )) {
          print("works");
        } else {
          print("doesn");
        }
      }
    }
  } catch (e, s) {
    print(s);
    print(e);
  }
}
