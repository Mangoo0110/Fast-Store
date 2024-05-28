RegExp moneyRegExp() {
  return RegExp(r'^\d*.(\.\d+)?$'); // r'^\d*.?\d{0,4}?$' r'^\d+(\.\d+)?$' r'^\d+(\.\d+)?$'  ^\d+(\.\d+)?$
}

RegExp integerRegExp() {
  return RegExp(r'^\d*');
}