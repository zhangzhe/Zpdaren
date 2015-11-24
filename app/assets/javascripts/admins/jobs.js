function changePriority(sel){
  var id = $(sel).attr('id');
  var priority = $(sel).val();
  $.ajax({
    type: 'PUT',
    url: '/admins/jobs/' + id + '/priority_update',
    data: { priority: priority },
    success: function(response){
      if (response['status'] == 200) {
        location.reload();
      }else{
        alert('程序异常，设置失败。');
      }
    },
    error: function(){
      alert('程序异常，设置失败。');
    }
  });
}
