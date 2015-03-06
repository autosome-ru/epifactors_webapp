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
  fulltext_searchable_by(searchable_attributes)
  define_search_by_attributes

  def to_s
    complex_name
  end

  # Not used now: for now it is done with JS on client side
  def genes_in_complex_names_only
    ComplexPattern.from_string(genes_in_complex).map{|genename_with_id|
      genename_with_id.match(/^(?<gene_name>.+)#(?<gene_id>\d+)$/)[:gene_name]
    }.to_s
  end

  # Is used to transform uniprot pattern into genes pattern.
  # The result is stored during seeding DB in the `genes_in_complex` field in DB (format is hgncSymbol#id so that both text and links can be reconstructed)
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
