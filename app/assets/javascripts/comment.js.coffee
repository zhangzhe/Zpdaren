$ ->
  $(".unthumbuped").click ->
    e.preventDefault()
    id = $(this).attr('comment-id')
    $(this).removeClass('unthumbuped')
    $(this).addClass('thumbuped')
    $.ajax '/comments/' + id + '/like',
      type: 'PUT',
      success: (data, textStatus, jqXHR) ->
        current_count = parseInt($("#" + id + '_like_count').attr('like-count'));
        $("#" + id + '_like_count').text((current_count + 1) + '个赞');
        $("#" + id + '_like_count').attr('like-count', current_count + 1);
      error: (jqXHR, textStatus, errorThrown) ->
          $(this).removeClass('thumbuped');
          $(this).addClass('unthumbuped');
          alert('点赞失败，请联系管理员！');
