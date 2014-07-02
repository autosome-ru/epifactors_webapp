page_ready = function() {
  convert_element = function(converter) {
    var inp = $(this).text();
    $(this).html( converter(inp) );
  };

  convert_each_element = function(converter) {
    var inp = $(this).text();
    $(this).html( transform_each(inp, converter) );
  };

  transform_each = function(input, converter) {
    var result = '';
    var elements = input.split(', ');
    $.each(elements, function(index, element){
      if (index) { result += ', '; }
      result += converter(element);
    });
    return result;
  }



  transform_each_uniprot = function(input, converter) {
    var result = '';
    var elements = input.split(new RegExp(/(\s*,\s*|\s*\(\s*|\s*\)\s*\+?\s*|\s*\|\s*)/));
    $.each(elements, function(index, element){
      if (index % 2 == 0) {
        result += converter(element);
      } else {
        result += element;
      }
    });
    return result;
  }

  convert_each_uniprot = function(converter) {
    var inp = $(this).text();
    $(this).html( transform_each_uniprot(inp, converter) );
  };



  convert_to_pmid = function() {
    convert_each_element.call(this, function(pmid) {
      return '<a href="http://www.ncbi.nlm.nih.gov/pubmed/' + pmid + '">' + pmid + '</a>';
    });
  };

  convert_to_mgi = function() {
    convert_each_element.call(this, function(mgi_name) {
      return '<a href="http://www.informatics.jax.org/searchtool/Search.do?query=' + mgi_name + '">' + mgi_name + '</a>';
    });
  };

  convert_to_uniprot = function() {
    convert_each_uniprot.call(this, function(uniprot) {
      return '<a href="http://www.uniprot.org/uniprot/' + uniprot +'">' + uniprot + '</a>';
    });
  };

  convert_to_hgnc = function() {
    convert_each_element.call(this, function(hgnc) {
      return '<a href="http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=' + hgnc + '">' + hgnc + '</a>';
    });
  };

  convert_to_uniprot_ac = function() {
    convert_each_element.call(this, function(uniprot_ac) {
      return '<a href="http://www.uniprot.org/uniprot/' + uniprot_ac + '">' + uniprot_ac + '</a>';
    });
  };


  convert_to_gene_id = function() {
    convert_each_element.call(this, function(gene_id) {
      return '<a href="http://www.ncbi.nlm.nih.gov/gene/' + gene_id + '">' + gene_id + '</a>';
    });
  };

  convert_to_refseq = function() {
    convert_each_element.call(this, function(refseq) {
      return '<a href="http://www.ncbi.nlm.nih.gov/nucleotide/' + refseq + '">' + refseq + '</a>';
    });
  };

  convert_to_ec = function() {
    convert_each_element.call(this, function(ec) {
      ec_parts = ec.split('.')
      ec_query = [];
      $.each(ec_parts, function(ec_part_index, ec_part) {
        if (Number(ec_part)) {
          ec_query.push('field' + (1 + ec_part_index) + '=' + ec_part)
        }
      });
      if (ec_query.length > 0) {
        return '<a href="http://enzyme.expasy.org/cgi-bin/enzyme/enzyme-search-ec?' + ec_query.join('&') + '">' + ec + '</a>';
      } else {
        return ec;
      }
    });


  };

  $('table#epigenes tbody td:nth-child(4)').each(convert_to_gene_id);
  $('table#histones tbody td:nth-child(4)').each(convert_to_gene_id);
  $('.gene_id').each(convert_to_gene_id);

  $('table#epigenes tbody td:nth-child(10)').each(convert_to_ec);
  $('table#histones tbody td:nth-child(10)').each(convert_to_ec);
  $('.ec_number').each(convert_to_ec);

  $('table#epigenes tbody td:nth-child(16)').each(convert_to_pmid);
  $('table#epigenes tbody td:nth-child(18)').each(convert_to_pmid);
  $('table#epigenes tbody td:nth-child(22)').each(convert_to_pmid);
  $('table#gene_complexes tbody td:nth-child(8)').each(convert_to_pmid);
  $('table#gene_complexes tbody td:nth-child(12)').each(convert_to_pmid);
  $('.pmid').each(convert_to_pmid);

  $('table#epigenes tbody td:nth-child(7)').each(convert_to_uniprot);
  $('table#histones tbody td:nth-child(7)').each(convert_to_uniprot);
  $('table#gene_complexes tbody td:nth-child(6)').each(convert_to_uniprot);
  $('.uniprot').each(convert_to_uniprot);

  $('table#epigenes tbody td:nth-child(8)').each(convert_to_mgi);
  $('table#histones tbody td:nth-child(8)').each(convert_to_mgi);
  $('.mgi').each(convert_to_mgi);

  $('table#epigenes tbody td:nth-child(2)').each(convert_to_hgnc);
  $('table#histones tbody td:nth-child(2)').each(convert_to_hgnc);
  $('.hgnc_id').each(convert_to_hgnc);

  $('table#epigenes tbody td:nth-child(5)').each(convert_to_refseq);
  $('table#epigenes tbody td:nth-child(9)').each(convert_to_refseq);
  $('table#histones tbody td:nth-child(5)').each(convert_to_refseq);
  $('table#histones tbody td:nth-child(9)').each(convert_to_refseq);
  $('.refseq').each(convert_to_refseq);

  $('table#epigenes tbody td:nth-child(6)').each(convert_to_uniprot_ac);
  $('table#histones tbody td:nth-child(6)').each(convert_to_uniprot_ac);
  $('.uniprot_ac').each(convert_to_uniprot_ac);

  // call the tablesorter plugin

  $(".tablesorter").tablesorter({
    theme: 'blue',
    widthFixed : true,
    widgets: ['zebra', 'columnSelector', 'stickyHeaders', 'filter'],
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
            tokens = tokens.concat( el.trim().split(', ') );
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
    },

    filter_reset : 'button.reset'
  });

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
    });

  // initialize column selector using default settings
  // note: no container is defined!
  $(".bootstrap-select-columns-popup").tablesorter({
    theme: 'blue',
    widgets: ['zebra', 'columnSelector', 'stickyHeaders']
  });
};

$(document).ready(page_ready)
$(document).on('page:load', page_ready)
