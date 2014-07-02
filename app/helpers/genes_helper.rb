module GenesHelper
  def gene_table_header(attr, options = {})
    table_header I18n.t("activerecord.attributes.gene.#{attr}"), options
  end
end
