class Histone < ActiveRecord::Base
  searchable_attributes = [ :hgnc_symbol, :status, :hgnc_id, :hgnc_name, :gene_id, :uniprot_ac, :uniprot_id, :domain, :mgi_symbol, :mgi_id,
                            :uniprot_ac_mm, :uniprot_id_mm, :gene_tag, :gene_desc, :complex_name, :targeted_by_protein, :targeted_by_complex, :comment ]
  include SearchableFullText
  searchable_by(searchable_attributes)

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
