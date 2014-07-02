module HistonesHelper
  def histone_table_header(attr, options = {})
    table_header I18n.t("activerecord.attributes.histone.#{attr}"), options
  end
end
