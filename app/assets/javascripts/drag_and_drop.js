//= require jquery-ui/draggable
//= require jquery-ui/droppable

$(function() {
  $( ".draggable_priority_tags" ).draggable();
  $( ".draggable_nomal_tags" ).draggable();

  $( "#droppable_priority_tags" ).droppable({
    drop: function drop( event, ui ) {
      $.ajax({
        type: 'PUT',
        url: '/admins/tags/update',
        data: { priority: 1, tag: $(ui.draggable).text() },
      });
    }
  });

  $( "#droppable_nomal_tags" ).droppable({
    drop: function( event, ui ) {
      $.ajax({
        type: 'PUT',
        url: '/admins/tags/update',
        data: { priority: 0, tag: $(ui.draggable).text() },
      });
    }
  });
});
