module HistonesHelper
  def histone_table_header(attr, options = {}, &block)
    table_header I18n.t("activerecord.attributes.histone.#{attr}"), options, &block
  end
end
