//= require ./formatters.js

;(function(epigeneDB, $, undefined) {
  epigeneDB.defaultWidgetOptions = {
    filter: {
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
      filter_external : '', // Possibly it will replace server-side search (not sure it's a good idea, but leave such a variant)

      filter_formatter: {
        '.splitted_terms_filter': function($cell, indx) {
          const $table = $cell.closest('table');
          const table  = $table[0];

          const $hidden = $('<input>', { type: 'hidden', class: 'ts-s2-hidden' })
            .appendTo($cell);

          const $select = $('<select>', {
            class: 'ts-s2',
            multiple: 'multiple',
            style: 'width: 100%'
          }).appendTo($cell);

          function uniqStrings(arr) {
            return [...new Set(
              (arr || [])
                .map(v => (v == null ? '' : String(v)).trim())
                .filter(v => v.length)
            )].sort((a,b) => a.localeCompare(b));
          }

          function escapeForQuotedFilter(v) {
            return String(v).replace(/\\/g, '\\\\').replace(/"/g, '\\"');
          }

          function toExactOrExpr(values) {
            // exact match через кавычки + OR через |
            return values.map(v => `"${escapeForQuotedFilter(v)}"`).join('|');
          }

          function applyFilterFromSelect() {
            const selected = $select.val() || [];
            $hidden
              .val(selected.length ? JSON.stringify(selected) : '')
              .trigger('search', false); // правильный вызов :contentReference[oaicite:2]{index=2}
          }

          function rebuildOptionsFromColumn(onlyAvail = false) {
            const raw = $.tablesorter.filter.getOptions(table, indx, onlyAvail);
            const values = uniqStrings(raw);

            const prevSelected = $select.val() || [];

            $select.empty();
            values.forEach(v => $select.append(new Option(v, v, false, prevSelected.includes(v))));

            // обновить UI Select2, не дергая наш change.tsfilter
            $select.trigger('change.select2');

            // если выбор изменился из-за пересборки — синхронизируем фильтр
            const nowSelected = $select.val() || [];
            if (nowSelected.join('\u0001') !== prevSelected.join('\u0001')) {
              applyFilterFromSelect();
            }
          }

          $select.select2({
            theme: 'bootstrap',
            closeOnSelect: false,
            width: 'resolve'
          });

          rebuildOptionsFromColumn(false);
          $select.on('change.tsfilter', applyFilterFromSelect);

          $table.on('filterEnd', function() {
            rebuildOptionsFromColumn(false);
          });

          return $hidden;
        }
      },

      filter_functions: {
        '.splitted_terms_filter': function(e, n, f, i, $r, c, data) {
          if (!f) return true; // пустой фильтр = показываем всё

          let selected;
          try {
            selected = JSON.parse(f);
          } catch (err) {
            // на случай если вдруг прилетело не JSON
            selected = [String(f)];
          }

          // нормализация регистра, если у вас включён ignoreCase
          const ignoreCase = c && c.widgetOptions ? c.widgetOptions.filter_ignoreCase : true;
          const norm = (s) => ignoreCase ? String(s).toLowerCase() : String(s);
          const selectedSet = new Set(selected.map(norm));

          // разбиваем содержимое ячейки на токены
          const tokens = String(e).split(',').map(s => s.trim()).filter(Boolean);

          // true если хотя бы один токен из ячейки входит в выбранные
          return tokens.some(t => selectedSet.has(norm(t)));
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
    },

    formatter: {
      formatter_column: epigeneDB.tablesorter_formatters,
    },
    stickyHeaders: {
      stickyHeaders_addResizeEvent : false,
    },
    saveSort: {},
    zebra: {},
    output: { // CSV output
      // TODO: Need fix in tablesorter to make it possible to remove group headers from output
      output_separator     : "\t",
      output_ignoreColumns : [],
      output_dataAttrib    : 'data-text', // the same attribute as is used in textAttribute config option (used by formatter widget and extractors)
      output_delivery      : 'd',         // (p)opup, (d)ownload
      output_saveRows      : 'f',         // (a)ll, (f)iltered or (v)isible
    },
    columnSelector: {
      columnSelector_saveColumns: true,
      columnSelector_mediaquery: false,
    },
    resizable: {
      resizable_addLastColumn: true,
    },
    group: {
      group_collapsible : true,
      group_collapsed : true,
      group_saveGroups : true,
    },
  };

  // It should be incorporated into widget options using deep-extend like this:
  // $.extend(true, {},
  //               epigeneDB.defaultConfig,
  //               epigeneDB.configForWidgets(['widget_1', 'widget_2'],
  //               {my: 'own configuration options', }
  //         )
  epigeneDB.configForWidgets = function(widgetList) {
    var widgetConfig = {};
    $.each(widgetList, function(i, widgetName){
      return $.extend(widgetConfig, epigeneDB.defaultWidgetOptions[widgetName] || {});
    });
    return {
      widgets: widgetList,
      widgetOptions: widgetConfig,
    };
  };

  epigeneDB.defaultConfig = {
    theme: 'blue',
    widthFixed : false, // This is default
    ignoreCase: true,
    // delayInit: false,
    initialized : function(table){
      $('.loading_table').hide();
    },
    onRenderHeader: function(index){
      $(this).find('.has-tooltip').tooltip(); // As headers can be rerendered, collective .tooltip() call doesn't work
    }
  }
})(window.epigeneDB = window.epigeneDB || {}, jQuery);
