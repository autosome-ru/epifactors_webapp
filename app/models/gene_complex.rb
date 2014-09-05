class GeneComplex < ActiveRecord::Base

  def uniprot_ids_splitted
    uniprot_id.gsub(/[?+()|]/, ', ').split(',').map(&:strip).reject(&:empty?)
    # uniprot_id.strip.split(',')
    #   .flat_map{|s| s.strip.split(/\(|\)\+?/)}
    #   .flat_map{|s| s.strip.split('|')}
    #   .flat_map{|one_uniprot_id| one_uniprot_id.strip.sub(/\?$/,'')}
  end

  def genes
    Gene.where(uniprot_id: uniprot_ids_splitted)
  end

  # searchable_attributes = [ :complex_group,:complex_group_name,:complex_name,:alternative_names,:proteins_involved,
  #                           :uniprot_ids,:funct,:specific_target,:target_molecule,:product,:target_uniprot_ids,:details]
  searchable_attributes = [ :group, :group_name, :complex_name, :status, :alternative_name, :protein, :uniprot_id,
                            :function, :target, :specific_target, :product, :uniprot_id_target, :comment ]
  include SearchableFullText
  searchable_by(searchable_attributes)
end
