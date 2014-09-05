class CreateGeneComplexes < ActiveRecord::Migration

  def change
    create_table :gene_complexes do |t|
      t.integer :group                      # Group
      t.string  :group_name                 # Group_name
      t.string  :complex_name               # Complex_name
      t.string  :status                     # Status
      t.string  :alternative_name           # Alternative_name
      t.text    :protein                    # Protein
      t.text    :uniprot_id                 # UniProt_ID
      t.string  :pmid_complex               # PMID_complex
      t.string  :function                   # Function
      t.string  :pmid_function              # PMID_function
      t.string  :target                     # Target
      t.string  :specific_target            # Specific_target
      t.string  :product                    # Product
      t.text    :uniprot_id_target          # Uniprot_ID_target
      t.string  :pmid_target                # PMID_target
      t.text    :comment                    # Comment

      t.timestamps
    end
  end
end
