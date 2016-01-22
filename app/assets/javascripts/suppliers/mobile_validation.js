$(function () {
  $("#UpdateSupplierMobile").click(function () {
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
    $('#UpdateSupplierMobile').attr('disabled', 'disabled');
    $('#UpdateSupplierMobile').attr("value", '提交中...');
    $("#update_mobile_form").submit();
  })
});
