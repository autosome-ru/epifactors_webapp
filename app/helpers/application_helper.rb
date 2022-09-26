module ApplicationHelper
  def table_info_row(obj, attrib, html_options: {}, header_cell: nil, attrib_name: nil, &block)
    key_column = content_tag(:td, html_options[:key_column_html]) do
      attrib_name ||= attrib
      header_cell || I18n.t("activerecord.attributes.#{ActiveSupport::Inflector.underscore(obj.class.model_name)}.#{attrib_name}")
    end
    value_column = content_tag(:td, html_options[:value_column_html]) do
      if block_given?
        block.call(obj).to_s
      else
        obj.send(attrib).to_s
      end
    end
    content_tag(:tr, html_options[:row_html]) do
      (key_column + value_column).html_safe
    end
  end

  def table_header(content, options = {}, &block)
    klasses = []
    klasses << 'sorter-false'  if options.delete(:dont_sort)
    klasses << 'columnSelector-disable'  if options.delete(:show_always)
    klasses << 'columnSelector-false'  if options.delete(:hide_by_default)
    if options[:class]
      klasses += options[:class]  if options[:class].is_a? Array
      klasses += options[:class].split(/[\s,]/)  if options[:class].is_a? String
    end
    content_tag :th, options.merge(class: klasses.uniq) do
      block_given? ? block.call(content) : content
    end
  end

  def download_button
    content_tag :button, 'Get CSV', class: ['download', 'has-tooltip'],
                                    type: 'button',
                                    data: { toggle: 'tooltip',
                                            placement: 'right',
                                            title: 'CSV export works in Firefox / Google Chrome / IE 11 only.'
                                          }
  end

  def full_name_button
    content_tag :button, 'Full/short names', class: ['toggle-sample-format', 'has-tooltip'],
                                    type: 'button',
                                    data: { toggle: 'tooltip',
                                            placement: 'right',
                                            title: 'Show or hide FANTOM5 library ID.'
                                          }
  end

  # "abc, def" --> "{decorated abc}, {decorated def}"
  def decorate_list(str, splitter: ", ", joiner: ", ", &decorating_block)
    str.split(splitter).map(&decorating_block).join(joiner).html_safe
  end

  def uniprot_id_or_ac_link(id)
    (id == '#') ? '#' : link_to(id, "http://www.uniprot.org/uniprot/#{id}")
  end

  def uniprot_id_or_ac_links(ids)
    decorate_list(ids){|id| uniprot_id_or_ac_link(id) }
  end

  def target_complex_link(target)
    link_to(target, "/protein_complexes?search=#{target}&field=complex_name")
  end

  def target_complex_links(targets)
    decorate_list(targets){|target| target_complex_link(target) }
  end

  def pfam_domain_link(pfam_domain)
    infos = pfam_domain.strip.split(/\s+/)
    url = "http://pfam.xfam.org/family/#{infos[1]}"
    domain_name = infos.first(2).join('&nbsp;').html_safe
    residues_ranges = infos.drop(2).join(', ')
    link_to(domain_name, url) + " (#{residues_ranges})"
  end

  def pfam_domain_links(pfam_domains)
    decorate_list(pfam_domains, joiner: '<br/>'){|pfam_domain| pfam_domain_link(pfam_domain) }
  end

  def pmid_link(pmid)
    if pmid.match(/^\d+$/)
      link_to("PMID:#{pmid}", "http://www.ncbi.nlm.nih.gov/pubmed/#{pmid}")
    else
      pmid # Some PMIDs look like "Uniprot", "by similarity" and "Uniprot (by similarity)"
    end
  end

  def pmid_links(pmid_list)
    decorate_list(pmid_list){|pmid| pmid_link(pmid) }
  end

  def fantom_sstar_gene_link(gene_id)
    link_to('SSTAR profile', "http://fantom.gsc.riken.jp/5/sstar/EntrezGene:#{gene_id}")
  end

  def gene_id_link(gene_id)
    [
      link_to("GeneID:#{gene_id}", "http://www.ncbi.nlm.nih.gov/gene/#{gene_id}"),
      '<br/>',
      "(#{ fantom_sstar_gene_link(gene_id) })"
    ].join.html_safe
  end

  def hgnc_id_url(hgnc_id)
    "http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=#{hgnc_id}"
  end
  def hgnc_id_link(hgnc_id, name: nil)
    link_to((name || "HGNC:#{hgnc_id}"), hgnc_id_url(hgnc_id))
  end

  def mgi_url(mgi_id)
    # "http://www.informatics.jax.org/searchtool/Search.do?query=MGI:#{mgi_id}"
    "http://www.informatics.jax.org/marker/MGI:#{mgi_id}"
  end
  def mgi_id_link(mgi_id, name: nil)
    link_to((name || "MGI:#{mgi_id}"), mgi_url(mgi_id))
  end
end
