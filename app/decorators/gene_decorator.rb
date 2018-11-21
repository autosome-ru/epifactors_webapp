class GeneDecorator < ApplicationDecorator
  delegate_all

  def hgnc_symbol_link
    ( object.hgnc_symbol + '<br/>' + h.link_to('(details)', h.gene_path(object)) ).html_safe
  end

  def hocomoco_link
    UniprotHocomocoMapping.instance.motifs_by_uniprots(object.uniprot_id, object.uniprot_id_mm).join(', ')
  end
end
