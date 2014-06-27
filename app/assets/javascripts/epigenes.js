$(function() {
  convert_to_pmid = function() {
    var result = $('<div></div>')
    var pmids = $(this).text().split(', ');
    $.each(pmids, function(index, pmid){
      if (index) { result.append(', '); }
      result.append( $('<a href="http://www.ncbi.nlm.nih.gov/pubmed/' + pmid + '">' + pmid + '</a>') );
    });
    $(this).html( result.html() ); 
  }

  convert_to_uniprot = function() {
    var uniprot = $(this).text();
    $(this).html( $('<a href="http://www.uniprot.org/uniprot/' + uniprot +'">' + uniprot + '</a>') );
  }

  convert_to_hgnc = function() {
    var hgnc = $(this).text();
    $(this).html( $('<a href="http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=' + hgnc + '">' + hgnc + '</a>') );
  }

  convert_to_uniprot_ac = function() {
    var uniprot_ac = $(this).text();
    $(this).html( $('<a href="http://www.uniprot.org/uniprot/' + uniprot_ac + '">' + uniprot_ac + '</a>') );
  }


  convert_to_gene_id = function() {
    var gene_id = $(this).text();
    $(this).html( $('<a href="http://www.ncbi.nlm.nih.gov/gene/' + gene_id + '">' + gene_id + '</a>') );
  }

  convert_to_refseq = function() {
    var result = $('<div></div>')
    var refseqs = $(this).text().split(', ');
    $.each(refseqs, function(index, refseq){
      if (index) { result.append(', '); }
      result.append( $('<a href="http://www.ncbi.nlm.nih.gov/nucleotide/' + refseq + '">' + refseq + '</a>') );
    });
    $(this).html( result.html() );
  }
  
  $('table#epigenes tbody td:nth-child(4)').each(convert_to_gene_id);
  $('.gene_id').each(convert_to_gene_id);

  $('table#epigenes tbody td:nth-child(16)').each(convert_to_pmid);
  $('table#epigenes tbody td:nth-child(18)').each(convert_to_pmid);
  $('table#epigenes tbody td:nth-child(22)').each(convert_to_pmid);
  $('table#complexes tbody td:nth-child(8)').each(convert_to_pmid);
  $('table#complexes tbody td:nth-child(12)').each(convert_to_pmid);
  $('.pmid').each(convert_to_pmid);

  $('table#epigenes tbody td:nth-child(7)').each(convert_to_uniprot);
  $('.uniprot').each(convert_to_uniprot);
  
  $('table#epigenes tbody td:nth-child(2)').each(convert_to_hgnc);
  $('.hgnc_id').each(convert_to_hgnc);
  
  $('table#epigenes tbody td:nth-child(5)').each(convert_to_refseq);
  $('table#epigenes tbody td:nth-child(9)').each(convert_to_refseq);
  $('.refseq').each(convert_to_refseq);
  
  $('table#epigenes tbody td:nth-child(6)').each(convert_to_uniprot_ac);
  $('.uniprot_ac').each(convert_to_uniprot_ac);

  // call the tablesorter plugin

  $("table#epigenes, table#complexes").tablesorter({
    theme: 'blue',
    widthFixed : true,
    widgets: ["zebra", "filter"],
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
      filter_formatter : null,

      // add custom filter functions using this option
      // see the filter widget custom demo for more specifics on how to use this option
      filter_functions : null,

      // if true, filters are collapsed initially, but can be revealed by hovering over the grey bar immediately
      // below the header row. Additionally, tabbing through the document will open the filter row when an input gets focus
      filter_hideFilters : true,

      // Set this option to false to make the searches case sensitive
      filter_ignoreCase : true,

      // if true, search column content while the user types (with a delay)
      filter_liveSearch : true,

      // a header with a select dropdown & this class name will only show available (visible) options within that drop down.
      filter_onlyAvail : 'filter-onlyAvail',

      // jQuery selector string of an element used to reset the filters
      filter_reset : 'button.reset',

      // Use the $.tablesorter.storage utility to save the most recent filters (default setting is false)
      filter_saveFilters : true,

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
      filter_defaultAttrib : 'data-value'
    }
  });
});
