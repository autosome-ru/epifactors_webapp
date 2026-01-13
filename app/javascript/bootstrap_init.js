export function initBootstrapWidgets() {
  if (!window.jQuery || !window.jQuery.fn) return;

  const $ = window.jQuery;

  if ($.fn.popover) {
    $("a[rel~=popover], .has-popover").popover();
  }

  if ($.fn.tooltip) {
    $("a[rel~=tooltip], .has-tooltip").tooltip();
  }
}
