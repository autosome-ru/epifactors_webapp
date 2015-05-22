module ProteinComplexesHelper
  def protein_complex_table_header(attr, options = {}, &block)
    table_header I18n.t("activerecord.attributes.protein_complex.#{attr}"), options, &block
  end

  def table_info_row_uniprot_comb(obj, html_options: {}, &block)
    key_name = I18n.t 'activerecord.attributes.protein_complex.uniprot_id'
    icon = content_tag :div, '', {class: ['export_uniprot', 'has-tooltip'], data: {toggle: 'tooltip', placement: 'bottom', title: 'Send proteins in complex to Uniprot.'} }
    table_info_row(obj, :uniprot_id, html_options: html_options, header_cell: "#{key_name}#{icon}".html_safe, &block)
  end
end
