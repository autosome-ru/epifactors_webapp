class ProteinComplexDecorator < Draper::Decorator
  delegate_all
  def complex_name_link(text = nil)
     h.link_to(text || object.complex_name, h.protein_complex_path(object))
  end

  def complex_name_with_complex_card_link
    ( object.complex_name + '<br/>' + complex_name_link('(complex info)') ).html_safe
  end
  def genes
    object.genes.map{|gene|
      h.link_to gene.hgnc_symbol, h.gene_path(gene)
    }.join(', ').html_safe
  end
end
