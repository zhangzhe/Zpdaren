$(document).ready(function(){
  $("#markdown_edit").click(function () {
    $('.nav-self').find('li').each(function(){
      $(this).removeClass('active')
    });
    $(this).addClass('active');
    $('#job_description').show();
    $('#preview').hide();
  })

  $("#markdown_preview").click(function () {
    $('.nav-self').find('li').each(function(){
      $(this).removeClass('active')
    });
    $(this).addClass('active');
    var description = $('#job_description').val();
    $.post('/jobs/preview', {description: description}, function(response){
      $('#preview').show();
      $('#job_description').hide();
      $('#preview').html(response['format_description']);
    });
  })
});
