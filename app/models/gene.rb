class Gene < ActiveRecord::Base
  def gene_complexes
    GeneComplex.where('uniprot_ids LIKE ? OR uniprot_ids LIKE ? OR uniprot_ids LIKE ? OR uniprot_ids LIKE ?', 
                      uniprot_id,
                      "%, #{uniprot_id},%",
                      "#{uniprot_id}, %",
                      "%, #{uniprot_id}" )
  end

  searchable_attributes = [ :hgnc_symbol, :hgnc_name, :refseq_hs,:uniprot_ac,:uniprot_id,:mgi_id,:refseq_mm,:ec_description,
                            :gene_tag,:gene_desc,:funct_class,:funct,:protein_complex,:target,:target_molecule,:product,:details]
  scope :by_word, ->(word) {
    if word.blank?
      all
    else
      where(searchable_attributes.map{|attr| "#{attr} LIKE ?"}.join(' OR '),
            *(["%#{word}%"]*searchable_attributes.size) )
    end
  }
end
