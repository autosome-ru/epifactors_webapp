class HistoneDecorator < Draper::Decorator
  delegate_all

  def molecule_kind
    object.hgnc_name.start_with?('protamine')  ? 'protamine' : 'histone'
  end

  def hgnc_symbol_link
    protein_info = "(details)"
    ( object.hgnc_symbol + '<br/>' + h.link_to(protein_info, h.histone_path(object)) ).html_safe
  end
end
