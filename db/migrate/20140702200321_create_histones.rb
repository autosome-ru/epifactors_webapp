class CreateHistones < ActiveRecord::Migration

  def change
    create_table :histones do |t|
      t.string  :hgnc_symbol          # HGNC_Symbol
      t.string  :status               # Status  
      t.integer :hgnc_id              # HGNC_ID 
      t.string  :hgnc_name            # HGNC_name 
      t.integer :gene_id              # GeneID  
      t.string  :uniprot_ac           # UniProt_AC  
      t.string  :uniprot_id           # UniProt_ID  
      t.string  :domain               # Domain  
      t.string  :mgi_symbol           # MGI_symbol  
      t.string  :mgi_id               # MGI_ID  
      t.string  :uniprot_ac_mm        # UniProt_AC_Mm 
      t.string  :uniprot_id_mm        # UniProt_ID_Mm 
      t.string  :gene_tag             # GeneTag 
      t.string  :gene_desc            # GeneDesc  
      t.string  :complex_name         # Complex_name  
      t.string  :targeted_by_protein  # Targeted_by_protein 
      t.string  :targeted_by_complex  # Targeted_by_complex
      t.string  :pmid                 # PMID
      t.string  :comment              # Comment

      t.timestamps
    end
  end
end
