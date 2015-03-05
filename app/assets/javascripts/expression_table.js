//= require ./tablesorter_defaults.js
//= require ./select_columns.js

var page_ready = function() {
  $("#samples").tablesorter(
    $.extend(true, {},
      epigeneDB.defaultConfig,
      epigeneDB.configForWidgets(['zebra', 'stickyHeaders', 'filter', 'output', 'formatter', 'group']),
      {
        // Sort by sample kind so that tissues become grouped; don't allow to resort tissue kinds (just because it's confusing)
        sortForce : [[0,0]],
        headers : {0: {sorter: false}},
        sortList : [[0,0]], // Sort by sample kind (for grouping)
        widgetOptions : {
          filter_saveFilters: false,
        }
      }
    )
  );

  $(".gene_expression_by_sample").tablesorter(
    $.extend(true, {},
      epigeneDB.defaultConfig,
      epigeneDB.configForWidgets(['zebra', 'stickyHeaders', 'filter', 'output', 'formatter', 'group']),
      {
        // Sort by sample kind so that tissues become grouped; don't allow to resort tissue kinds (just because it's confusing)
        sortForce : [[0,0]],
        headers : {0: {sorter: false}},
        sortList : [[0,0],[2,1]], // Sort by sample kind (for grouping) then by expression descending
        widgetOptions : {
          filter_saveFilters: false,
        }
      }
    )
  );

  $(".sample-expressions").tablesorter(
    $.extend(true, {},
      epigeneDB.defaultConfig,
      epigeneDB.configForWidgets(['zebra', 'stickyHeaders', 'filter', 'output', 'formatter', 'columnSelector', 'group']),
      {
        // Sort by types (gene/histone/protamine) so that tissues become grouped; don't allow to resort molecule types (just because it's confusing)
        sortForce : [[0,0]],
        headers : {0: {sorter: false}},
        sortList : [[0,0],[3,1]], // Sort by molecule type (for grouping), then by expression descending
        widgetOptions : {
          filter_saveFilters: false,
        }
      }
    )
  );
};

$(document).ready(page_ready);
$(document).on('page:load', page_ready);
