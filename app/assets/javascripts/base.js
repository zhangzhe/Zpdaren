function isNull(s){
  return s == null;
}

function isEmptyString(s){
  return $.trim(s) == ''
}

function isPositiveInteger(s){
  if (!isNull(s) && !isEmptyString(s)) {
    var regular = /^\d+$/ ;
    var result = s.match(regular);
    return !isNull(result) ? true:false;
  }
  return false;
}
