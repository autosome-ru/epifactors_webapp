class GeneComplexDecorator < Draper::Decorator
  delegate_all

  def genes
    object.genes.map{|gene|
      h.link_to gene.hgnc_symbol, h.gene_path(gene)
    }.join(', ').html_safe
  end
end
