//= require ./tablesorter_defaults.js
//= require ./select_columns.js

var page_ready = function() {
  $(".gene_expression_by_sample, #samples").tablesorter(
    $.extend(true, {},
      epigeneDB.defaultConfig,
      epigeneDB.configForWidgets(['zebra', 'stickyHeaders', 'filter', 'output', 'formatter', 'group']),
      {
        // Sort by sample kind so that tissues became grouped; don't allow to resort tissue kinds (just because it's confusing)
        sortForce : [[0,0]],
        headers : {0: {sorter: false}},
        sortList : [[0,0]],
        widgetOptions : {
          filter_saveFilters: false,
        }
      }
    )
  );

  $(".sample-expressions").tablesorter(
    $.extend(true, {},
      epigeneDB.defaultConfig,
      epigeneDB.configForWidgets(['zebra', 'stickyHeaders', 'filter', 'output', 'formatter', 'columnSelector']),
      {
        sortList : [[3,1]], // Sort by expression descending
        widgetOptions : {
          filter_saveFilters: false,
        }
      }
    )
  );
};

$(document).ready(page_ready);
$(document).on('page:load', page_ready);
