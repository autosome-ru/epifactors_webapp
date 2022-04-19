module LncrnasHelper
  def lncrna_table_header(attr, options = {}, &block)
  table_header I18n.t("activerecord.attributes.lncrna.#{attr}"), options, &block
  end
end
