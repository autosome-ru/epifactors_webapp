class GeneDecorator < Draper::Decorator
  delegate_all

  def gene_complexes
    object.gene_complexes.map{|gene_complex|
      h.link_to gene_complex.complex_name, h.gene_complex_path(gene_complex)
    }.join(', ').html_safe
  end

  def refseq_mm
    (object.refseq_mm || '').split('|').join(', ')
  end

  def refseq_hs
    (object.refseq_hs || '').split('|').join(', ')
  end
end
