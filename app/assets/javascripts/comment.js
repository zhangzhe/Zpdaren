$(function () {
  $(".unthumbuped").click(function () {
    var id = $(this).attr('comment-id');
    $(this).removeClass('unthumbuped');
    $(this).addClass('thumbuped');
    $(this).removeAttr("onclick");
    $.ajax({
      type: 'PUT',
      url: '/comments/' + id + '/like',
      success: function(response){
        if (response['status'] == 200) {
          var current_count = parseInt($("#" + id + '_like_count').attr('like-count'));
          $("#" + id + '_like_count').text((current_count + 1) + '个赞');
          $("#" + id + '_like_count').attr('like-count', current_count + 1);
        }
        else {
          $(this).removeClass('thumbuped');
          $(this).addClass('unthumbuped');
          alert('点赞失败，请联系管理员！');
        }
      }
    });
  })
});
