jQuery ->
  $(document).on "click", ".unthumbuped", ->
    id = $(this).attr('comment-id')
    $.ajax '/comments/' + id + '/like', type: 'PUT'
