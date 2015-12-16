$(function(){
  $(".resumesForJob").popover(
    {
      html: true
    }
  );
});

function validMobile(){
  var mobile = $('#supplier_mobile').val();
  if ($.trim(mobile) == '') {
    $('.alert-danger').html("手机号不能为空");
    $('.alert-danger').show();
    return false;
  };
  if ($.trim(mobile).length != 11) {
    $(".alert-danger").html('请输入11位的手机号');
    $('.alert-danger').show();
    return false;
  };
  submitting($('#submitBtn'));
  return true;
}

function submitting(e){
  $(e).attr('disabled', 'disabled');
  $(e).attr("value", '提交中...');
}
