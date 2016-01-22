$(function () {
  $(".job-priority-sel").change(function () {
    var id = $(this).attr('id');
    var priority = $(this).val();
    $.ajax({
      type: 'PUT',
      url: '/admins/jobs/' + id + '/priority_update',
      data: { priority: priority },
      success: function(response){
        if (response['status'] == 200) {
          Turbolinks.visit(location.toString());
        }else{
          alert('程序异常，设置失败。');
        }
      },
      error: function(){
        alert('程序异常，设置失败。');
      }
    });
  })
});
