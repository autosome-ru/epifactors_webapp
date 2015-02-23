;(function(epigeneDB, $, undefined) {

  epigeneDB.gene_id_link = function(gene_id) {
    return '<a href="http://www.ncbi.nlm.nih.gov/gene/' + gene_id + '">' + gene_id + '</a>';
  };

  epigeneDB.hgnc_id_link = function(hgnc) {
    return '<a href="http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=' + hgnc + '">' + hgnc + '</a>';
  };

  epigeneDB.mgi_id_link = function(mgi_name) {
    // return '<a href="http://www.informatics.jax.org/searchtool/Search.do?query=MGI:' + mgi_name + '">' + mgi_name + '</a>';
    return '<a href="http://www.informatics.jax.org/marker/MGI:' + mgi_name + '">' + mgi_name + '</a>';
  };

  epigeneDB.uniprot_id_link = function(uniprot_id) {
    return '<a href="http://www.uniprot.org/uniprot/' + uniprot_id +'" class="uniprot_id_term">' + uniprot_id + '</a>';
  };

  epigeneDB.uniprot_ac_link = function(uniprot_ac) {
    return '<a href="http://www.uniprot.org/uniprot/' + uniprot_ac + '">' + uniprot_ac + '</a>';
  };

  epigeneDB.refseq_link = function(refseq) {
    return '<a href="http://www.ncbi.nlm.nih.gov/nucleotide/' + refseq + '">' + refseq + '</a>';
  };

  epigeneDB.pmid_link = function(pmid) {
    return '<a href="http://www.ncbi.nlm.nih.gov/pubmed/' + pmid + '">' + pmid + '</a>';
  };

  epigeneDB.target_complex_link = function(target) {
    return '<a href="/protein_complexes?complex_name=' + target + '">' + target + '</a>';
  };

  epigeneDB.pfam_domain_link = function(pfam_info) {
    var infos = $.trim(pfam_info).split(/\s+/);
    return '<a href="http://pfam.xfam.org/family/' + infos[1] + '">' + infos.slice(0, 2).join('&nbsp;') + '</a> (' + infos.slice(2).join(', ') + ')';
  };

  epigeneDB.expression_bar = function(value, data) {
    var tbodyIndex      = data.config.$tbodies.index( data.$cell.parents('tbody').filter(':first') ),
        max_expression  = data.config.cache[tbodyIndex].colMax[data.columnIndex],
        percentage      = 100.0 * value / max_expression;
    return Number(value).toFixed(1) + '<div class="expression-bar" style="width:' + percentage + '%;">' + '</div>';
  };

  epigeneDB.sample_link = function(value, data) {
    var match, name, library_id, extract_name, sample_format, url;
    match = /^(.+)\.(CNhs\w+)\.(\w+-\w+)?$/.exec(value);
    name = match[1];
    library_id = match[2];
    extract_name = match[3];
    sample_format = data.$header.data('sample-format');
    url = '/samples/' + library_id;
    fantom_sstar_url = 'http://fantom.gsc.riken.jp/5/sstar/FF:' + extract_name;
    if (!sample_format || sample_format == 'short') {
      return '<a href="' + url + '"">' + name + '</a> <span class="fantom-external-link">(<a href="' + fantom_sstar_url + '">FANTOM5 SSTAR</a>)</span>';
    } else if (sample_format == 'full') {
      return '<a href="' + url + '">' + value + '</a> <span class="fantom-external-link">(<a href="' + fantom_sstar_url + '">FANTOM5 SSTAR</a>)</span>';
    } else {
      return value;
    }
  };

  epigeneDB.ec_number_link = function(ec) {
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

  epigeneDB.hocomoco_link = function(value) {
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

  var uniprot_id_comb_markup_alternatives,
      uniprot_markup_term,
      multiterm,
      formatter_preserving_text,
      make_tablesorter_formatters;

  // 'abc|def' --> '<div class="alternative_uniprot">abc</div><div class="alternative_uniprot">def</div>']
  uniprot_id_comb_markup_alternatives = function(uniprot_comb_part) {
    var tokens = [''];
    for (var i = 0; i < uniprot_comb_part.length; ++i) {
      if (uniprot_comb_part[i] == '|') {
        tokens.push('');
      } else {
        tokens[tokens.length - 1] += uniprot_comb_part[i];
      }
    }
    return $.map(tokens, function(token) {
      return '<span class="uniprot_comb_alternative">' + uniprot_markup_term($.trim(token)) + '</span>';
    }).join(' | ');
  };

  uniprot_markup_term = function(term) {
    if (term.slice(-1) == '+') {
      return '<span class="uniprot_comb_multiple">' + uniprot_markup_term(term.slice(0, -1)) + '+</span>';
    } else if (term.slice(-1) == '?') {
      return '<span class="uniprot_comb_optional">' + uniprot_markup_term(term.slice(0, -1)) + '?</span>';
    } else if (term.slice(0, 1) == '(' && term.slice(-1) == ')') {
      return '<span class="uniprot_comb_alternative_group">(' + uniprot_id_comb_markup_alternatives(term.slice(1, -1)) + ')</span>';
    } else {
      return epigeneDB.uniprot_id_link(term);
    }
  };

  epigeneDB.uniprot_id_comb_link = function(uniprot_comb) {
    var tokens = [''];
    for (var i = 0; i < uniprot_comb.length; ++i) {
      if (uniprot_comb[i] == ',') {
        tokens.push('');
      } else {
        tokens.push(tokens.pop() + uniprot_comb[i]);
      }
    }
    tokens = $.map(tokens, $.trim);
    return '<span class="uniprot_comb">' + $.map(tokens, uniprot_markup_term).join(', ') + '</span>';
  };

  multiterm = function(apply_func, joining_sequence, splitter_pattern) {
    if (typeof(splitter_pattern)==='undefined') splitter_pattern = ', ';
    if (typeof(joining_sequence)==='undefined') joining_sequence = ', ';
    return function(multiple_ids) {
      var terms = multiple_ids.split(splitter_pattern);
      terms = $.map(terms, $.trim);
      return $.map(terms, apply_func).join(joining_sequence)
    };
  };

  formatter_preserving_text = function(formatter) {
    return function(text, data) {
      data.$cell.attr(data.config.textAttribute, text);
      return formatter(text, data);
    };
  };

  make_tablesorter_formatters = function(formatters) {
    var result = {},
        selector;
    for (selector in formatters) {
      result[selector] = formatter_preserving_text(formatters[selector]);
    }
    return result;
  };

  epigeneDB.formatters = {
    '.gene_id'         : epigeneDB.gene_id_link,
    '.ec_number'       : epigeneDB.ec_number_link,
    '.hgnc_id'         : epigeneDB.hgnc_id_link,
    '.mgi_id'          : epigeneDB.mgi_id_link,
    '.uniprot_ac'      : epigeneDB.uniprot_ac_link,
    '.refseq'          : epigeneDB.refseq_link,
    '.uniprot_id_comb' : epigeneDB.uniprot_id_comb_link,
    '.expression_bar'  : epigeneDB.expression_bar,
    '.sample_link'     : epigeneDB.sample_link,
    '.pmid'            : multiterm( epigeneDB.pmid_link ),
    '.target_complex'  : multiterm( epigeneDB.target_complex_link),
    '.uniprot_id'      : multiterm( epigeneDB.uniprot_id_link ),
    '.pfam_domain'     : multiterm( epigeneDB.pfam_domain_link, '<br/>' ),
    '.hocomoco'        : multiterm( epigeneDB.hocomoco_link, '' ), // hocomoco links with motif logos go on different lines, comma is unnecessary
  };

  epigeneDB.tablesorter_formatters = make_tablesorter_formatters(epigeneDB.formatters);

  epigeneDB.apply_formatters = function(jquery_selector) {
    var selector, formatter;
    for (selector in epigeneDB.formatters) {
      formatter = epigeneDB.formatters[selector];

      $(jquery_selector).filter(selector).each(function(ind, elem) {
        $(elem).html( formatter($(elem).text()) );
      });
    };
  };

})(window.epigeneDB = window.epigeneDB || {}, jQuery);
