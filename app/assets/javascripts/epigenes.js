//= require ./formatters.js
//= require ./select_columns.js

var page_ready = function() {
  var columns_by_header = function(table_selector, header_classes) {
    var header_indices = $(table_selector).find('thead tr th').filter(header_classes).map(function() {
      return $(this).index();
    });
    return $.unique(header_indices);
  };

  $('.download').click(function(){
    $('table.tablesorter').get(0).config.widgetOptions.output_saveFileName = $('.csv-filename').val();
    $('table.tablesorter').trigger('outputTable');
  });

  epigeneDB.apply_formatters( $('tbody:not(.tablesorter)').find('td') );

  $(".tablesorter").tablesorter({
    theme: 'blue',
    widthFixed : true,
    widgets: ['saveSort', 'zebra', 'columnSelector', 'stickyHeaders', 'filter', 'output', 'formatter'/*, 'resizable'*/],
    ignoreCase: false,
    widgetOptions : {
      formatter_column: epigeneDB.tablesorter_formatters,

      stickyHeaders_addResizeEvent : false,

      columnSelector_saveColumns: true,
      columnSelector_mediaquery: false,

      filter_columnFilters : true,
      filter_hideFilters : false,
      filter_saveFilters: true,
      filter_ignoreCase : true,
      filter_liveSearch : true,
      filter_onlyAvail : 'filter-onlyAvail',
      filter_reset : 'button.reset',
      filter_searchDelay : 300,
      filter_startsWith : false,
      filter_useParsedData : false,

      filter_formatter : {
        '.splitted_terms_filter' : function($cell, indx){
          return $.tablesorter.filterFormatter.select2( $cell, indx, {
            match : false,
            multiple: true
          });
        }
      },

      filter_functions : {
        '.splitted_terms_filter' : function(exact_text, normalized_text, search_for, column_index, $row) {
          // `/pattern/` string --> /pattern/ regexp
          var search_regexp = eval(search_for);
          var tokens = $.trim(exact_text).split(', ');

          for(var i = 0; i < tokens.length; ++i) {
            if (search_regexp.test(tokens[i])) {
              return true;
            }
          }
          return false;
        }
      },

      filter_selectSource : {
        '.splitted_terms_filter' : function(table, column, onlyAvail){
          // get an array of all table cell contents for a table column
          var array = $.tablesorter.filter.getOptions(table, column, onlyAvail);
          // manipulate the array as desired, then return it
          var tokens = [];

          $.each(array, function(i,el) {
            var tokens_in_cell = $.map(el.split(', '), $.trim);
            tokens = tokens.concat( tokens_in_cell );
          });

          return $.unique(tokens).filter(function(el){
            return el.length > 0;
          });
        }
      },

      filter_external : '', // Possibly it will replace server-side search (not sure it's a good idea, but leave such a variant)

      // CSV output
      output_separator     : "\t",
      output_ignoreColumns : [],
      output_dataAttrib    : 'data-text', // the same attribute as is used in textAttribute config option (used by formatter widget and extractors)
      output_delivery      : 'd',         // (p)opup, (d)ownload
      output_saveRows      : 'f',         // (a)ll, (f)iltered or (v)isible

      // resizable_addLastColumn: true,
    },

    // delayInit: false,
    initialized : function(table){
      $('table.gene_expression_by_sample').find('td:nth-child(3), th:nth-child(3)').show();

      table.config.widgetOptions.output_ignoreColumns = columns_by_header(table, '.ignore_csv_output');
      $('.loading_table').hide();
    }
  });

  epigeneDB.ui.applyColumnSelector();

  $('.uniprot_comb').find('.uniprot_comb_multiple, .uniprot_comb_alternative_group, .uniprot_comb_optional').find('.uniprot_id_term').tooltip({
    container: 'body', // not to draw tooltip on an optional element opaque
    title: function(){
      var texts = [], $el = $(this);
      if ($el.closest('.uniprot_comb_multiple').length) {
        texts.push('More than one member of this list can be included.');
      }
      if ($el.closest('.uniprot_comb_alternative_group').length) {
        texts.push('These members are alternative.');
      }
      if ($el.closest('.uniprot_comb_optional').length) {
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
