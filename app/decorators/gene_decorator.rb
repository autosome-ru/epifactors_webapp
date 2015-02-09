class GeneDecorator < Draper::Decorator
  delegate_all

  def hgnc_symbol_link
    ( object.hgnc_symbol + '<br/>' + h.link_to('(details)', h.gene_path(object)) ).html_safe
  end

  def refseq_mm
    (object.refseq_mm || '').split('|').join(', ')
  end

  def refseq_hs
    (object.refseq_hs || '').split('|').join(', ')
  end

  def hocomoco_link
    UniprotHocomocoMapping.instance.hocomoco_motifs(object.uniprot_id, object.uniprot_id_mm).join(', ')
  end
end
