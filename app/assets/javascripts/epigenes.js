//= require ./tablesorter_defaults.js
//= require ./select_columns.js

var page_ready = function() {

  $('.download').click(function(){
    $('table.tablesorter').get(0).config.widgetOptions.output_saveFileName = $('.csv-filename').val();
    $('table.tablesorter').trigger('outputTable');
  });

  epigeneDB.apply_formatters( $('tbody:not(.tablesorter)').find('td') );

  $("#epigenes, #protein-complexes, #histones").filter('table.tablesorter').tablesorter(
    $.extend(true, {},
      epigeneDB.defaultConfig,
      epigeneDB.configForWidgets(['saveSort', 'zebra', 'columnSelector', 'stickyHeaders', 'filter', 'output', 'formatter', /*, 'resizable'*/]),
      { } // custom options
    )
  );

  epigeneDB.ui.applyColumnSelector();

  $('.comb').find('.comb_multiple, .comb_alternative_group, .comb_optional').find('.comb_term').tooltip({
    container: 'body', // not to draw tooltip on an optional element opaque
    title: function(){
      var texts = [], $el = $(this);
      if ($el.closest('.comb_multiple').length) {
        texts.push('More than one member of this list can be included.');
      }
      if ($el.closest('.comb_alternative_group').length) {
        texts.push('These members are alternative.');
      }
      if ($el.closest('.comb_optional').length) {
        texts.push('This member is facultative.');
      }
      return texts.join(' ');
    }
  });

  $('.toggle-sample-format').click(function(e){
    var $table = $('.toggle-sample-format-target')
        $sample_header = $table.find('thead th.sample_link'),
        sample_format = $sample_header.data('sample-format');
    e.preventDefault();
    if (!sample_format || sample_format == 'short') {
      $sample_header.data('sample-format', 'full')
    } else {
      $sample_header.data('sample-format', 'short')
    }

    $sample_header.trigger('applyFormatter');
    return false;
  });
};

$(document).ready(page_ready);
$(document).on('page:load', page_ready);
