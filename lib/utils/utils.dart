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
