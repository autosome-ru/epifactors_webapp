class HistoneDecorator < ApplicationDecorator
  delegate_all

  def hgnc_symbol_link
    protein_info = "(details)"
    ( object.hgnc_symbol + '<br/>' + h.link_to(protein_info, h.histone_path(object)) ).html_safe
  end
end
