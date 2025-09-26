String numToRupiah(int number) {
  var temp = number.toString();
  for (var i = 3; i < temp.length; i += 4) {
    temp =
        "${temp.substring(0, temp.length - i)}.${temp.substring(temp.length - i, temp.length)}";
  }
  return "Rp.$temp,00";
}
