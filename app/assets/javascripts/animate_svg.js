// multiplicate_size('20px', 1.5)
multiplicate_size = function(size, multiplier) {
  infos = size.match(/^(\d+(\.\d*)?)(\D+)$/);
  if (infos == null) return null;
  sz = infos[1];
  units = infos[3];
  return (sz * multiplier) + units;
}


set_css_attr = function(selector, attr, val_function) {
  $(selector).each(function(i, element) {
    if (typeof( $(element).data("old-css-value-"+attr) ) == 'undefined') {
      var old_value = $(element).css(attr);
      $(element).css(attr, val_function(old_value));
      $(element).data("old-css-value-"+attr, old_value);
    }
  });
};

restore_css_attr = function(selector, attr) {
  $(selector).each(function(i, element) {
    var old_value = $(element).data("old-css-value-"+attr);
    if (typeof( $(element).data("old-css-value-"+attr) ) != 'undefined') {
      $(element).css(attr, old_value);
      $(element).removeData("old-css-value-"+attr);
    }
  });
};


set_attr = function(selector, attr, val_function) {
  $(selector).each(function(i, element) {
    if (typeof( $(element).data("old-attr-value-"+attr) ) == 'undefined') {
      var old_value = element.getAttribute(attr);
      element.setAttribute(attr, val_function(old_value));
      $(element).data("old-attr-value-"+attr, old_value);
    }
  });
};

restore_attr = function(selector, attr) {
  $(selector).each(function(i, element) {
    var old_value = $(element).data("old-attr-value-"+attr);
    if (typeof( $(element).data("old-attr-value-"+attr) ) != 'undefined') {
      element.setAttribute(attr, old_value);
      $(element).removeData("old-attr-value-"+attr);
    }
  });
};

// sx  0   cx(1-sx)
// 0   sy  cy(1-sy)
// 0   0   1
rescale = function(element, scale_x, scale_y) {
  var coords = element.getBBox();
  var cx = coords.x + coords.width / 2.0;
  var cy = coords.y + coords.height / 2.0;
  $(element).css('transform','matrix('+[scale_x,0, 0, scale_y, cx*(1-scale_x), cy*(1-scale_y)].join(',')+')');
};

rescale_svg = function(element, scale_x, scale_y) {
  $(element).children().attr('transform', 'scale('+[scale_x, scale_y].join(',')+')');
}

animate_svg = function() {
  var image = $('#main_scheme_svg');
  var epigenes = image.find('g.epigene');
  var histones = image.find('g.histone');
  var pseudocomplexes = image.find('g.pseudocomplex');
  epigenes.hover(
    function(e) {
      var name = $(e.target).closest('g.epigene').data('epigene-name');
      var same_epigenes = epigenes.filter('[data-epigene-name="'+name+'"]');

      set_css_attr(same_epigenes.find('path'), 'fill', function(){return 'red';} );
      same_epigenes.each(function(i,el){ rescale(el,1.5,1.5); });
    },
    function(e) {
      var name = $(e.target).closest('g.epigene').data('epigene-name');
      var same_epigenes = epigenes.filter('[data-epigene-name="'+name+'"]');

      restore_css_attr(same_epigenes.find('path'), 'fill');
      same_epigenes.each(function(i,el){ rescale(el,1,1); });
    }
  );

  pseudocomplexes.hover(
    function(e) {
      var name = $(e.target).closest('g.pseudocomplex').data('pseudocomplex-name');
      var same_pseudocomplexes = pseudocomplexes.filter('[data-pseudocomplex-name="'+name+'"]');

      set_css_attr(same_pseudocomplexes.find('path'), 'fill', function(){return '#c2271f';} );
      same_pseudocomplexes.each(function(i,el){ rescale(el,1.5,1.5); });
    },
    function(e) {
      var name = $(e.target).closest('g.pseudocomplex').data('pseudocomplex-name');
      var same_pseudocomplexes = pseudocomplexes.filter('[data-pseudocomplex-name="'+name+'"]');

      restore_css_attr(same_pseudocomplexes.find('path'), 'fill');
      same_pseudocomplexes.each(function(i,el){ rescale(el,1,1); });
    }
  );

  histones.hover(
    function(e) {
      var name = $(e.target).closest('g.histone').data('histone-name');
      var same_histones = histones.filter('[data-histone-name="'+name+'"]');

      same_histones.each(function(i,el){ rescale(el,2.5,2.5); });
    },
    function(e) {
      var name = $(e.target).closest('g.histone').data('histone-name');
      var same_histones = histones.filter('[data-histone-name="'+name+'"]');

      same_histones.each(function(i,el){ rescale(el,1,1); });
    }
  );

  epigenes.click(function(e) {
    var name = $(e.target).closest('g.epigene').data('epigene-name');
    window.location = '/protein_complexes?search='+name+'&field=group_name&similar=1';
  });

  histones.click(function(e) {
    var name = $(e.target).closest('g.histone').data('histone-name');
    window.location = '/histones?search=' + name + '&field=uniprot_id&similar=1';
  });

  pseudocomplexes.click(function(e) {
    var name = $(e.target).closest('g.pseudocomplex').data('pseudocomplex-name');
    window.location = '/genes?search=' + name + '&field=hgnc_symbol&similar=1';
  });
};


onload_callback = function() {
  animate_svg();
  $('#main_scheme_png_stub').hide();
  $('.loading_figure').hide();
};

load_svg = function() {
  //$('#main_scheme_svg').load('https://gattaca.imppc.org/svgs/main_scheme.svg', null, function(response, status, xhr) {
  $('#main_scheme_svg').load('https://epigene-db.appspot.com/images/main_scheme.svg', null, function(response, status, xhr) {
    if (status == "error") {
        $('#main_scheme_svg').load('/main_scheme.svg', null, onload_callback);
    } else {
      onload_callback();
    }
  });
}

$(document).ready(load_svg)
