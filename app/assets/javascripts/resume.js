$(document).ready(function(){
  var checkBox = $('.checkbox').find("input[type='checkbox']")
  $(checkBox).click(function(){
    if ($(checkBox).is(':checked')) {
      $('.pdfAttachment').hide();
    }else{
      $('.pdfAttachment').show();
    }
  });
});
