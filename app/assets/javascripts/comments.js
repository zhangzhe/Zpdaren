function follow(e){
  var id = $(e).attr('comment-id');
  $(e).removeClass('unfollowed');
  $(e).addClass('followed');
  var current_count = parseInt($("#" + id + '_like_count').attr('like-count'));
  $("#" + id + '_like_count').text((current_count + 1) + '个赞');
  $("#" + id + '_like_count').attr('like-count', current_count + 1);
  $(e).removeAttr("onclick");
  $.ajax({
    type: 'PUT',
    url: '/comments/' + id + '/like',
    success: function(response){
      if (response['status'] == 'ERROR') {
        alert('程序异常，点赞失败。');
      }
    }
  });
}
