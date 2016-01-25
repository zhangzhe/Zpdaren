$(document).ready ->
    $(".unthumbuped").click ->
      id = $(this).attr('comment-id')
      $.ajax '/comments/' + id + '/like', type: 'PUT'
