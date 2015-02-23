var page_ready = function() {
  $(".gene_expression_by_sample.tablesorter").tablesorter({
    theme: 'blue',
    widthFixed : true,
    widgets: ['zebra', 'stickyHeaders', 'filter', 'output', 'formatter', 'group'],
    ignoreCase: false,

    // Sort by sample kind so that tissues became grouped; don't allow to resort tissue kinds (just because it's confusing)
    sortForce : [[0,0]],
    headers : {0: {sorter: false}},
    sortList : [[0,0]],

    widgetOptions : {
      formatter_column: epigeneDB.tablesorter_formatters,

      stickyHeaders_addResizeEvent : false,

      filter_columnFilters : true,
      filter_hideFilters : false,
      filter_saveFilters: false,
      filter_ignoreCase : true,
      filter_liveSearch : true,
      filter_onlyAvail : 'filter-onlyAvail',
      filter_reset : 'button.reset',
      filter_searchDelay : 300,
      filter_startsWith : false,
      filter_useParsedData : false,

      group_collapsible : true,
      group_collapsed : true,
      group_saveGroups : true,
      group_separator:  'never occurs',

      // CSV output
      // Need fix in tablesorter to make it possible to remove group headers from output
      output_separator     : "\t",
      output_ignoreColumns : [],
      output_dataAttrib    : 'data-text', // the same attribute as is used in textAttribute config option (used by formatter widget and extractors)
      output_delivery      : 'd',         // (p)opup, (d)ownload
      output_saveRows      : 'f',         // (a)ll, (f)iltered or (v)isible
    },

    // delayInit: false,
    initialized : function(table){
      $('.loading_table').hide();
    }
  });
};

$(document).ready(page_ready);
$(document).on('page:load', page_ready);
