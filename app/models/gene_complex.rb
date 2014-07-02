class GeneComplex < ActiveRecord::Base
  def genes
    ids = uniprot_ids.strip.split(',')
      .flat_map{|s| s.strip.split(/\(|\)\+?/)}
      .flat_map{|s| s.strip.split('|')}
      .flat_map{|uniprot_id| uniprot_id.strip.sub(/\?$/,'')}

    Gene.where(uniprot_id: ids)
  end

  searchable_attributes = [ :complex_group,:complex_group_name,:complex_name,:alternative_names,:proteins_involved,
                            :uniprot_ids,:funct,:target,:target_molecule,:product,:details]
  scope :by_word, ->(word) {
    if word.blank?
      all
    else
      where(searchable_attributes.map{|attr| "#{attr} LIKE ?"}.join(' OR '),
            *(["%#{word}%"]*searchable_attributes.size) )
    end
  }
end
