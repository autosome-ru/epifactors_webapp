page_ready = function() {

  methodToFunction = function(meth) {
    return function(el) {
      return meth.call(el);
    };
  };

  convert_argument = function(converter) {
    var inp = $(this).text();
    $(this).html( converter(inp) );
    if ( !$(this).attr('data-original-value') ) {
      $(this).attr('data-original-value', inp);
    }
  };

  convert_element = function(converter) {
    return function() { convert_argument.call(this, converter); };
  };

  // pattern MUST be a single group, otherwise spliter-terms won't be in split results;
  // multiple groups will result in several indistinguashable partial splitter terms. So use /(pattern)/ with pattern without (groups)
  convert_each_token_with = function(converter, splitter_pattern) {
    if (typeof(splitter_pattern)==='undefined') splitter_pattern = /([\s?|()+,]+)/;

    return function(input) {
      var result = '';
      // var elements = input.split(new RegExp(/(\s*,\s*|\s*\(\s*|\s*\)\s*\+?\s*|\s*\|\s*)/));
      var elements = input.split(splitter_pattern);
      $.each(elements, function(index, element){
        if (splitter_pattern.test(element)) { // splitters goes as they go
          result += element;
        } else {
          result += converter(element);
        }
      });
      return result;
    };
  };

  convert_multiple = function(apply_func, joining_sequence, splitter_pattern) {
    if (typeof(splitter_pattern)==='undefined') splitter_pattern = /,/;
    if (typeof(joining_sequence)==='undefined') joining_sequence = ', ';
    return function(multiple_ids) {
      // return multiple_ids.split(splitter_pattern).map(function(el){ return apply_func( el.trim() ); }).join(joining_sequence)
      return multiple_ids.split(splitter_pattern).map(methodToFunction(String.prototype.trim)).map(apply_func).join(joining_sequence)
    };
  };

  pmid_link = function(pmid) {
    return '<a href="http://www.ncbi.nlm.nih.gov/pubmed/' + pmid + '">' + pmid + '</a>';
  };
  mgi_id_link = function(mgi_name) {
    // return '<a href="http://www.informatics.jax.org/searchtool/Search.do?query=MGI:' + mgi_name + '">' + mgi_name + '</a>';
    return '<a href="http://www.informatics.jax.org/marker/MGI:' + mgi_name + '">' + mgi_name + '</a>';
  };
  uniprot_id_link = function(uniprot_id) {
    return '<a href="http://www.uniprot.org/uniprot/' + uniprot_id +'">' + uniprot_id + '</a>';
  };
  hgnc_id_link = function(hgnc) {
    return '<a href="http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=' + hgnc + '">' + hgnc + '</a>';
  };
  uniprot_ac_link = function(uniprot_ac) {
    return '<a href="http://www.uniprot.org/uniprot/' + uniprot_ac + '">' + uniprot_ac + '</a>';
  };
  gene_id_link = function(gene_id) {
    return '<a href="http://www.ncbi.nlm.nih.gov/gene/' + gene_id + '">' + gene_id + '</a>';
  };
  refseq_link = function(refseq) {
    return '<a href="http://www.ncbi.nlm.nih.gov/nucleotide/' + refseq + '">' + refseq + '</a>';
  };
  pfam_domain_link = function(pfam_info) {
    var infos = pfam_info.trim().split(/\s+/);
    return '<a href="http://pfam.xfam.org/family/' + infos[1] + '">' + infos.slice(0, 2).join('&nbsp;') + '</a> (' + infos.slice(2).join(', ') + ')';
  };

  target_complex_link = function(target) {
    return '<a href="/gene_complexes?complex_name=' + target + '">' + target + '</a>';
  };

  ec_number_link = function(ec) {
    var ec_parts = ec.split('.');
    var ec_query = [];
    $.each(ec_parts, function(ec_part_index, ec_part) {
      if (Number(ec_part)) {
        ec_query.push('field' + (1 + ec_part_index) + '=' + ec_part);
      }
    });
    if (ec_query.length > 0) {
      return '<a href="http://enzyme.expasy.org/cgi-bin/enzyme/enzyme-search-ec?' + ec_query.join('&') + '">' + ec + '</a>';
    } else {
      return ec;
    }
  };

  expression_bar = function(value) {
    return '<div class="expression-bar" style="width:' + value + 'px;"></div>';
  };

  hocomoco_link = function(value) {
    if (value == '') {
      return '';
    }
    var parts = value.split('_');
    var tf = parts[0];
    var model = parts[1];
    var img_html = '<img src="http://autosome.ru/HOCOMOCO/logos/thumbs/' + value + '_thumb.jpg">';
    var link_html = '<a href="http://autosome.ru/HOCOMOCO/modelDetails.php?tf=' + tf + '&model=' + model + '">' +
                    value + img_html +
                    '</a>';
    return '<div class="hocomoco_link">' + link_html + '</div>';
  };

  // convert_to_uniprot    = function() { convert_each_uniprot.call(this, uniprot_id_link); };


  columns_by_header = function(table_selector, header_classes) {
    var header_indices = $(table_selector).find('thead tr th').filter(header_classes).map(function() {
      return $(this).index();
    });
    return $.unique(header_indices);
  };

  apply_to_columns = function(table_selector, header_classes, apply_func) {
    var $table_selector = $(table_selector)
    var header_indices = columns_by_header($table_selector, header_classes);
    $.each(header_indices, function(i, column_index) {
      $table_selector.find('tbody tr td:nth-child(' + (column_index + 1) + ')').each(apply_func);
    });
  };

  // applies transformation to every element with given class and to every cell in a column with header of given class
  apply_converter = function(element_classes, apply_func) {
    var transformation_func = convert_element(apply_func);
    apply_to_columns('table', element_classes, transformation_func); // applied to any table, not a specific one
  };

  apply_converter_to_non_table = function(element_classes, apply_func) {
    var transformation_func = convert_element(apply_func);
    $(element_classes).filter(':not(th)').each(transformation_func); // not applied to header names in tables but to any other element
  };

  $('.download').click(function(){
    $('table.tablesorter').trigger('outputTable');
  });
  $('.csv-filename').change(function(e){
    $('.tablesorter')[0].config.widgetOptions.output_saveFileName = $(e.target).val();
  });

  $(".tablesorter").tablesorter({
    theme: 'blue',
    widthFixed : true,
    widgets: ['zebra', 'columnSelector', 'stickyHeaders', 'filter', 'output'],
    ignoreCase: false,
    widgetOptions : {
      filter_childRows : false,

      // if true, a filter will be added to the top of each table column;
      // disabled by using -> headers: { 1: { filter: false } } OR add class="filter-false"
      // if you set this to false, make sure you perform a search using the second method below
      filter_columnFilters : true,

      // extra css class name(s) applied to the table row containing the filters & the inputs within that row
      // this option can either be a string (class applied to all filters) or an array (class applied to indexed filter)
      filter_cssFilter : '', // or []

      // jQuery selector (or object) pointing to an input to be used to match the contents of any column
      // please refer to the filter-any-match demo for limitations - new in v2.15
      filter_external : '',

      // class added to filtered rows (rows that are not showing); needed by pager plugin
      filter_filteredRow   : 'filtered',

      // add custom filter elements to the filter row
      // see the filter formatter demos for more specifics
      // filter_formatter : null,

      // add custom filter functions using this option
      // see the filter widget custom demo for more specifics on how to use this option
      filter_functions : null,

      // if true, filters are collapsed initially, but can be revealed by hovering over the grey bar immediately
      // below the header row. Additionally, tabbing through the document will open the filter row when an input gets focus
      filter_hideFilters : false,

      // Set this option to false to make the searches case sensitive
      filter_ignoreCase : true,

      // if true, search column content while the user types (with a delay)
      filter_liveSearch : true,

      // a header with a select dropdown & this class name will only show available (visible) options within that drop down.
      filter_onlyAvail : 'filter-onlyAvail',

      // jQuery selector string of an element used to reset the filters
      filter_reset : 'button.reset',

      // Use the $.tablesorter.storage utility to save the most recent filters (default setting is false)
      filter_saveFilters : false,

      // Delay in milliseconds before the filter widget starts searching; This option prevents searching for
      // every character while typing and should make searching large tables faster.
      filter_searchDelay : 300,

      // if true, server-side filtering should be performed because client-side filtering will be disabled, but
      // the ui and events will still be used.
      filter_serversideFiltering: false,

      // Set this option to true to use the filter to find text from the start of the column
      // So typing in "a" will find "albert" but not "frank", both have a's; default is false
      filter_startsWith : false,

      // Filter using parsed content for ALL columns
      // be careful on using this on date columns as the date is parsed and stored as time in seconds
      filter_useParsedData : false,

      // data attribute in the header cell that contains the default filter value
      filter_defaultAttrib : 'data-value',


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
          var tokens = exact_text.trim().split(', ');

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
            tokens = tokens.concat( el.split(',').map(methodToFunction(String.prototype.trim)) );
          });
          return $.unique(tokens).filter( function(el) { return el.length > 0; } );
        }
      },

      // extra class name added to the sticky header row
      stickyHeaders : '',
      // number or jquery selector targeting the position:fixed element
      stickyHeaders_offset : 0,
      // added to table ID, if it exists
      stickyHeaders_cloneId : '-sticky',
      // trigger "resize" event on headers
      stickyHeaders_addResizeEvent : true,
      // if false and a caption exist, it won't be included in the sticky header
      stickyHeaders_includeCaption : true,
      // The zIndex of the stickyHeaders, allows the user to adjust this to their needs
      stickyHeaders_zIndex : 2,
      // jQuery selector or object to attach sticky header to
      stickyHeaders_attachTo : null,
      // scroll table top into view after filtering
      stickyHeaders_filteredToTop: true,


      // // target the column selector markup
      // columnSelector_container : $('#columnSelector'),
      // // column status, true = display, false = hide
      // // disable = do not display on list
      // columnSelector_columns : {
      //   0: 'disable' /* set to disabled; not allowed to unselect it */
      // },
      // remember selected columns (requires $.tablesorter.storage)
      columnSelector_saveColumns: false,

      // container layout
      columnSelector_layout : '<label><input type="checkbox">{name}</label>',
      // data attribute containing column name to use in the selector container
      columnSelector_name  : 'data-selector-name',

      /* Responsive Media Query settings */
      // enable/disable mediaquery breakpoints
      columnSelector_mediaquery: false,
      // // toggle checkbox name
      // columnSelector_mediaqueryName: 'Auto: ',
      // // breakpoints checkbox initial setting
      // columnSelector_mediaqueryState: false,
      // // responsive table hides columns with priority 1-6 at these breakpoints
      // // see http://view.jquerymobile.com/1.3.2/dist/demos/widgets/table-column-toggle/#Applyingapresetbreakpoint
      // // *** set to false to disable ***
      // columnSelector_breakpoints : [ '20em', '30em', '40em', '50em', '60em', '70em' ],
      // // data attribute containing column priority
      // // duplicates how jQuery mobile uses priorities:
      // // http://view.jquerymobile.com/1.3.2/dist/demos/widgets/table-column-toggle/
      // columnSelector_priority : 'data-priority'


      output_separator     : "\t",         // ',' 'json', 'array' or separator (e.g. ',')
      output_ignoreColumns : [],          // columns to ignore [0, 1,... ] (zero-based index)
      output_dataAttrib    : 'data-original-value', // data-attribute containing alternate cell text
      output_headerRows    : true,        // output all header rows (multiple rows)
      output_delivery      : 'd',         // (p)opup, (d)ownload
      output_saveRows      : 'f',         // (a)ll, (f)iltered or (v)isible
      // output_duplicateSpans: true,        // duplicate output data in tbody colspan/rowspan
      // output_replaceQuote  : '\u201c;',   // change quote to left double quote
      // output_includeHTML   : true,        // output includes all cell HTML (except the header cells)
      output_trimSpaces    : false,       // remove extra white-space characters from beginning & end
      // output_wrapQuotes    : false,       // wrap every cell output in quotes
      // output_popupStyle    : 'width=580,height=310',
      output_saveFileName  : 'data.csv',
      // callbackJSON used when outputting JSON & any header cells has a colspan - unique names required
      output_callbackJSON  : function($cell, txt, cellIndex) { return txt + '(' + cellIndex + ')'; },
      // callback executed when processing completes
      // return true to continue download/output
      // return false to stop delivery & do something else with the data
      output_callback      : function(config, data) { return true; },

      // the need to modify this for Excel no longer exists
      output_encoding      : 'data:application/octet-stream;charset=utf8,'
    },

    filter_reset : 'button.reset',
    // delayInit: false,
    initialized : function(table){
      apply_converter('.gene_id',         gene_id_link);
      apply_converter('.pmid',            convert_multiple(pmid_link));
      apply_converter('.target_complex',  convert_multiple(target_complex_link));
      apply_converter('.ec_number',       ec_number_link);
      apply_converter('.hgnc_id',         hgnc_id_link);
      apply_converter('.mgi_id',          mgi_id_link);
      apply_converter('.uniprot_id',      convert_multiple(uniprot_id_link));
      apply_converter('.uniprot_id_comb', convert_each_token_with(uniprot_id_link));
      apply_converter('.uniprot_ac',      uniprot_ac_link);
      apply_converter('.refseq',          refseq_link);
      apply_converter('.pfam_domain',     convert_multiple(pfam_domain_link, '<br/>'));
      apply_converter('.expression_bar',  expression_bar);
      table.config.widgetOptions.output_saveFileName = $('.csv-filename').val();
      table.config.widgetOptions.output_ignoreColumns = columns_by_header(table, '.ignore_csv_output');
      $('.loading_table').hide();
    }
  });

  $.fn.check = function() {
    this.each(function(ind, el) {
      if (! $(el).is(':checked')) {
        this.click();
      }
    });
  };
  $.fn.uncheck = function() {
    this.each(function(ind, el) {
      if ($(el).is(':checked')) {
        this.click();
      }
    });
  };

  $('#popover')
    .popover({
      placement: 'right',
      html: true, // required if content has HTML
      content: '<div id="popover-target"></div>'
    })
    // bootstrap popover event triggered when the popover opens
    .on('shown.bs.popover', function () {
      // call this function to copy the column selection code into the popover
      $.tablesorter.columnSelector.attachTo( $('.bootstrap-select-columns-popup'), '#popover-target');
      var buttons_html =  '<div>' +
                          '<a href="#" class="default-columns">Default</a> / ' +
                          '<a href="#" class="hide-all">Hide all</a> / ' +
                          '<a href="#" class="show-all">Show all</a>' +
                          '</div>'
      $('#popover-target').prepend($(buttons_html));
      $('#popover-target .show-all').click(function(e) {
        e.preventDefault;
        $(e.target).closest('#popover-target').find('input:checkbox').check();
        return false;
      });
      $('#popover-target .hide-all').click(function(e) {
        e.preventDefault;
        $(e.target).closest('#popover-target').find('input:checkbox').uncheck();
        return false;
      });
      $('#popover-target .default-columns').click(function(e) {
        e.preventDefault;
        $('.bootstrap-select-columns-popup thead th').each(function(index, el) {
          var column_index = $(el).data('column');
          if ($(el).is('.columnSelector-false')) {
            $(e.target).closest('#popover-target').find('input:checkbox[data-column=' + column_index + ']').uncheck();
          } else {
            $(e.target).closest('#popover-target').find('input:checkbox[data-column=' + column_index + ']').check();
          }
        });
        return false;
      });
    });

  // Ilya: Don't understand whether it's neccesary
  // initialize column selector using default settings
  // note: no container is defined!
  $(".bootstrap-select-columns-popup").tablesorter({
    theme: 'blue',
    widgets: ['zebra', 'columnSelector', 'stickyHeaders', 'output']
  });

  apply_converter_to_non_table('.gene_id',         gene_id_link);
  apply_converter_to_non_table('.pmid',            convert_multiple(pmid_link));
  apply_converter_to_non_table('.target_complex',  convert_multiple(target_complex_link));
  apply_converter_to_non_table('.ec_number',       ec_number_link);
  apply_converter_to_non_table('.hgnc_id',         hgnc_id_link);
  apply_converter_to_non_table('.mgi_id',          mgi_id_link);
  apply_converter_to_non_table('.uniprot_id',      convert_multiple(uniprot_id_link));
  apply_converter_to_non_table('.uniprot_id_comb', convert_each_token_with(uniprot_id_link));
  apply_converter_to_non_table('.uniprot_ac',      uniprot_ac_link);
  apply_converter_to_non_table('.refseq',          refseq_link);
  apply_converter_to_non_table('.pfam_domain',     convert_multiple(pfam_domain_link, '<br/>'));
  apply_converter_to_non_table('.hocomoco',        convert_multiple(hocomoco_link, ''));
};

$(document).ready(page_ready)
$(document).on('page:load', page_ready)
