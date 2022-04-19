class CreateLncrnas < ActiveRecord::Migration
  def change
    create_table :lncrnas do |t|
      t.string :hgnc_symbol
      t.string :status
      t.string :hgnc_id
      t.string :alternative_names
      t.string :hgnc_name
      t.string :gene_id
      t.string :gene_tag
      t.string :gene_desc
      t.text :function
      t.string :pmid_function
      t.string :target
      t.string :specific_target
      t.string :uniprot_id_target
      t.string :pmid_target
      t.text :comment

      t.timestamps null: false
    end
  end
end
