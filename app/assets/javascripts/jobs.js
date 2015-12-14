function edit(e) {
  $('.nav-self').find('li').each(function(){
    $(this).removeClass('active')
  });
  $(e).addClass('active');
  $('#job_description').show();
  $('#preview').hide();
}

function preview(e){
  $('.nav-self').find('li').each(function(){
    $(this).removeClass('active')
  });
  $(e).addClass('active');
  var description = $('#job_description').val();
  $.post('/jobs/preview', {description: description}, function(response){
    $('#preview').show();
    $('#job_description').hide();
    $('#preview').html(response['format_description']);
  });
}
