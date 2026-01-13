class Lncrna < ApplicationRecord
  searchable_attributes = [
      :hgnc_symbol, :hgnc_id, :alternative_names, :hgnc_name, 
      :gene_id, :gene_tag, :gene_desc, 
      :function, :target, :specific_target, :uniprot_id_target, 
      :comment
    ]

  include SearchableFullText
  fulltext_searchable_by(searchable_attributes)
  define_search_by_attributes

  def gene_expressions
    @gene_expressions ||= GeneExpressions.instance.expressions_by_hgnc(hgnc_id)
  end

  def gene_expressions_with_quantiles
    @gene_expressions_with_quantiles ||= GeneExpressions.instance.expressions_with_quantiles_by_hgnc(hgnc_id)
  end

  def expression_statistics
    @expression_statistics ||= Statistics.new(gene_expressions.map{|k,v| v })
  end

  def to_s
    hgnc_symbol
  end

  def molecule_kind
    'lncrna'
  end
  
end
