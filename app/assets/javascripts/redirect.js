$(function() {
  redirect_to_root_after_5_ss();
})
function redirect_to_root_after_5_ss() {
  setTimeout(function(){window.location.href='/'}, 5000);
}
