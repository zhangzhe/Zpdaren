function salaryValidate () {
  var salaryMin = $("#job_salary_min").val();
  var salaryMax = $("#job_salary_max").val();
  if ((!isNull(salaryMin) && !isEmptyString(salaryMin)) && (!isNull(salaryMin) && !isEmptyString(salaryMax))) {
    if (isPositiveInteger(salaryMin) && isPositiveInteger(salaryMax)) {
      if (parseInt(salaryMin) > parseInt(salaryMax)) {
        showHint('最高月薪不能低于最低月薪');
        return false;
      };
      return true;
    }
  }
  showHint('月薪必须为大于等于0的整数');
  return false;
}

function showHint(message){
  if ($(".salary_range").children('.red-color').length > 0) {
    $(".salary_range").children('.red-color').remove();
  }
  $(".salary_range").append("<p class='fs12 red-color'>"+message+"<p>");
}
