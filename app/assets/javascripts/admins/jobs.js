$(function () {
  $(".job-priority-sel").change(function () {
    var id = $(this).attr('id');
    var priority = $(this).val();
    $.ajax({
      type: 'PUT',
      url: '/admins/jobs/' + id + '/priority_update',
      data: { priority: priority }
    });
  })
});
