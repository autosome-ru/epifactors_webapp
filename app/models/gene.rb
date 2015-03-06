class Gene < ActiveRecord::Base
  has_many :gene_in_complexes
  has_many :protein_complexes, :through => :gene_in_complexes

  searchable_attributes = [
    :hgnc_symbol, :hgnc_id, :hgnc_name, :gene_id, :uniprot_ac, :uniprot_id,
    :domain, :mgi_symbol, :mgi_id, :uniprot_ac_mm, :uniprot_id_mm, :gene_tag,
    :gene_desc, :function, :modification, :complex_name, :target,
    :specific_target, :product, :uniprot_id_target, :comment
  ]

  include SearchableFullText
  fulltext_searchable_by(searchable_attributes)
  define_search_by_attributes

  def tf?
    function.split(',').map(&:strip).include?('TF')
  end

  def gene_expressions
    @gene_expressions ||= GeneExpressions.instance.expressions_by_hgnc(hgnc_id)
  end
  def expression_statistics
    @expression_statistics ||= Statistics.new(gene_expressions.map{|k,v| v })
  end

  def to_s
    hgnc_symbol
  end
end
