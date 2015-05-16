module ProteinComplexesHelper
  def protein_complex_table_header(attr, options = {}, &block)
    table_header I18n.t("activerecord.attributes.protein_complex.#{attr}"), options, &block
  end
end
