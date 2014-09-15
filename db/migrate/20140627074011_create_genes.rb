class CreateGenes < ActiveRecord::Migration

  def change
    create_table :genes do |t|
      t.string  :hgnc_symbol            # HGNC_symbol
      t.string  :status                 # Status
      t.string  :hgnc_id                # HGNC_ID
      t.string  :hgnc_name              # HGNC_name
      t.string  :gene_id                # GeneID
      t.string  :uniprot_ac             # UniProt_AC
      t.string  :uniprot_id             # UniProt_ID
      t.text    :domain                 # Domain
      t.string  :mgi_symbol             # MGI_symbol
      t.string  :mgi_id                 # MGI_ID
      t.string  :uniprot_ac_mm          # UniProt_AC_Mm
      t.string  :uniprot_id_mm          # UniProt_ID_Mm
      t.string  :gene_tag               # GeneTag
      t.string  :gene_desc              # GeneDesc
      t.string  :functional_class       # Functional_class
      t.string  :function               # Function
      t.string  :pmid_function          # PMID_function
      t.string  :complex_name           # Complex_name
      t.string  :target                 # Target
      t.string  :specific_target        # Specific_target
      t.string  :product                # Product
      t.string  :uniprot_id_target      # UniProt_ID_target
      t.string  :pmid_target            # PMID_target
      t.text    :comment                # Comment

      t.timestamps
    end
  end
end
