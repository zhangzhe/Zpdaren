function iFrameHeight(e) {
  var id = e.getAttribute('id');
  var subWeb = document.frames ? document.frames[id].document : e.contentDocument;
  if(e != null && subWeb != null) {
     e.height = subWeb.body.scrollHeight;
  }
}
