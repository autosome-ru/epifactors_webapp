module GenesHelper
  def gene_table_header(attr, options = {}, &block)
    table_header I18n.t("activerecord.attributes.gene.#{attr}"), options, &block
  end
end
