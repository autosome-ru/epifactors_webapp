class GeneDecorator < Draper::Decorator
  delegate_all

  def protein_complexes
    object.protein_complexes.map{|protein_complex|
      h.link_to protein_complex.complex_name, h.protein_complex_path(protein_complex)
    }.join(', ').html_safe
  end

  def hgnc_symbol
    ( object.hgnc_symbol + '<br/>' + h.link_to('(gene info)', h.gene_path(object)) ).html_safe
  end

  def refseq_mm
    (object.refseq_mm || '').split('|').join(', ')
  end

  def refseq_hs
    (object.refseq_hs || '').split('|').join(', ')
  end

  def hocomoco_link
    UniprotHocomocoMapping.instance.hocomoco_motifs(object.uniprot_id, object.uniprot_id_mm).join(',')
  end
end
