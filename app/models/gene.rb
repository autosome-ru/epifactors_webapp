class Gene < ActiveRecord::Base
  # # BAD DEFINITION
  # def gene_complexes
  #   GeneComplex.where('uniprot_ids LIKE ? OR uniprot_ids LIKE ? OR uniprot_ids LIKE ? OR uniprot_ids LIKE ?', 
  #                     uniprot_id,
  #                     "%, #{uniprot_id},%",
  #                     "#{uniprot_id}, %",
  #                     "%, #{uniprot_id}" )
  # end

  searchable_attributes = [
    :hgnc_symbol, :hgnc_id, :hgnc_name, :gene_id, :uniprot_ac, :uniprot_id,
    :domain, :mgi_symbol, :mgi_id, :uniprot_ac_mm, :uniprot_id_mm, :gene_tag,
    :gene_desc, :functional_class, :function, :complex_name, :target,
    :specific_target, :product, :uniprot_id_target, :comment
  ]

  # searchable_attributes = [ :hgnc_symbol, :hgnc_name, :refseq_hs,:uniprot_ac,:uniprot_id,:mgi_id,:refseq_mm,:ec_description,
                            # :gene_tag,:gene_desc,:funct_class,:funct,:protein_complex,:target,:target_molecule,:product,:details]
  include SearchableFullText
  searchable_by(searchable_attributes)
end
