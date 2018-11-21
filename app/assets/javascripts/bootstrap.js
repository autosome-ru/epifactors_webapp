var page_ready = function() {
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()
};

$(document).ready(page_ready);
