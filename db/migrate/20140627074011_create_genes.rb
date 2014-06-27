class CreateGenes < ActiveRecord::Migration
  def change
    create_table :genes do |t|
      t.string :hgnc_symbol
      t.integer :hgnc_id
      t.string :hgnc_name
      t.integer :gene_id
      t.string :refseq_hs
      t.string :uniprot_ac
      t.string :uniprot_id
      t.string :mgi_id
      t.string :refseq_mm
      t.string :ec_number
      t.string :ec_description
      t.string :gene_tag
      t.string :gene_desc
      t.string :funct_class
      t.string :funct
      t.string :funct_pmid
      t.string :protein_complex
      t.string :protein_complex_pmid
      t.string :target
      t.string :target_molecule
      t.string :product
      t.string :product_pmid
      t.text :details

      t.timestamps
    end
  end
end
