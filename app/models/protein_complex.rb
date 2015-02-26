class ProteinComplex < ActiveRecord::Base
  has_many :gene_in_complexes
  has_many :genes, :through => :gene_in_complexes
  def uniprot_ids_splitted
    uniprot_id.gsub(/[?+()|]/, ', ').split(',').map(&:strip).reject(&:empty?)
    # uniprot_id.strip.split(',')
    #   .flat_map{|s| s.strip.split(/\(|\)\+?/)}
    #   .flat_map{|s| s.strip.split('|')}
    #   .flat_map{|one_uniprot_id| one_uniprot_id.strip.sub(/\?$/,'')}
  end

  # Now this information is stored into an association table (GeneInComplex model) and loaded via SQL for all complexes at once
  # def genes
  #   Gene.where(uniprot_id: uniprot_ids_splitted)
  # end

  searchable_attributes = [ :group_name, :complex_name, :status, :alternative_name, :protein, :uniprot_id,
                            :function, :target, :specific_target, :product, :uniprot_id_target, :comment ]
  include SearchableFullText
  searchable_by(searchable_attributes)

  def to_s
    complex_name
  end

  def involved_genes
    ComplexPattern.from_string(uniprot_id).map{|uniprot_id|
      genes = Gene.where(uniprot_id: uniprot_id).all
      if genes.size > 1
        ComplexPattern::Any.new(genes.map{|gene| ComplexPattern::Term.new(gene) })
      elsif genes.size == 1
        ComplexPattern::Term.new(genes.first)
      else
        nil
      end
    }
  end
end
