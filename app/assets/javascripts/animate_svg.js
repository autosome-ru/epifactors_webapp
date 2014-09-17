// multiplicate_size('20px', 1.5)
multiplicate_size = function(size, multiplier) {
  infos = size.match(/^(\d+(\.\d*)?)(\D+)$/);
  if (infos == null) return null;
  sz = infos[1];
  units = infos[3];
  return (sz * multiplier) + units;
}

bind_two_position_handler = function(element, css_feature, eventOn, eventOff, new_value_func) {
  var old_css_value = null;
  $(element).bind(eventOn, function() {
    if (old_css_value == null) {
      old_css_value = $(this).css(css_feature);
      $(this).css(css_feature, new_value_func(old_css_value));
    }
  });

  $(element).bind(eventOff, function() {
    if (old_css_value != null) {
      $(this).css(css_feature, old_css_value);
      old_css_value = null;
    }
  });
}

animate_svg = function() {
  var image = $('.main_scheme_svg');
  var $elements = image.find('.factor-CAF1');
  var $texts = image.find('text.factor-CAF1');
  var $backgrounds = image.find('path.factor-CAF1');
  $texts.each(function(i,el) {
    bind_two_position_handler(el, 'font-size', 'upscale', 'downscale', function(font_size) {
      return multiplicate_size(font_size,1.1);
    });
  });
  $backgrounds.each(function(i,el) {
    bind_two_position_handler(el, 'fill', 'saturateBG', 'desaturateBG', function(old_fill) {
      return 'red';
    });
  });
  // $texts.each(function(i,el) { bind_updownscale_handler(el); } );
  // $backgrounds.each(function(i,el) { bind_BGSaturator_handler(el); } );

  $elements.hover(
    function(e){
      $texts.trigger('upscale');
      $backgrounds.trigger('saturateBG');
    },
    function(e){
      $texts.trigger('downscale');
      $backgrounds.trigger('desaturateBG');
    }
  );
};

$(document).ready(animate_svg)
$(document).on('page:load', animate_svg)
