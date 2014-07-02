module GeneComplexesHelper
  def gene_complex_table_header(attr, options = {})
    table_header I18n.t("activerecord.attributes.gene_complex.#{attr}"), options
  end
end
