import 'package:flutter/material.dart';

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
