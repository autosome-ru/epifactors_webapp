class CreateHistones < ActiveRecord::Migration
  def change
    create_table :histones do |t|
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
      t.string :ec_descr
      t.string :gene_tag
      t.string :gene_desc

      t.timestamps
    end
  end
end
