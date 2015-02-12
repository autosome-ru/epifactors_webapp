module SamplesHelper
  def sample_table_header(attr, options = {})
    table_header I18n.t("activerecord.attributes.sample.#{attr}"), options
  end
end
