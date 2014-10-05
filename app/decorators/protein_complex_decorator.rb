class ProteinComplexDecorator < Draper::Decorator
  delegate_all
  def complex_name
    ( object.complex_name + '<br/>' + h.link_to('(complex info)', h.protein_complex_path(object)) ).html_safe
  end
  def genes
    object.genes.map{|gene|
      h.link_to gene.hgnc_symbol, h.gene_path(gene)
    }.join(', ').html_safe
  end
end
