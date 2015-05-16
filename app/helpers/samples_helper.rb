module SamplesHelper
  def sample_table_header(attr, options = {}, &block)
    table_header I18n.t("activerecord.attributes.sample.#{attr}"), options, &block
  end
end
