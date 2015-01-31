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
end
