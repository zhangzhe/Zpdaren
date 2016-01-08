function follow(e){
  var id = $(e).attr('comment-id');
  $.ajax({
    type: 'PUT',
    url: '/comments/' + id + '/like',
    success: function(response){
      if (response['status'] == 'OK') {
        $(e).removeClass('unfollowed');
        $(e).addClass('followed');
        $("#" + id + '_like_count').text(response['like_count'] + '个赞');
        $(e).removeAttr("onclick");
      }else{
        alert('程序异常，点赞失败。');
      }
    }
  });
}
