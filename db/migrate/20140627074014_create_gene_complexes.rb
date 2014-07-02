class CreateGeneComplexes < ActiveRecord::Migration
  def change
    create_table :gene_complexes do |t|
      t.integer :complex_group
      t.string :complex_group_name
      t.string :complex_name
      t.string :alternative_names
      t.text :proteins_involved
      t.text :uniprot_ids
      t.string :funct
      t.string :complex_members_pmid
      t.string :target
      t.string :target_molecule
      t.string :product
      t.string :function_pmid
      t.string :targets_and_products_pmid
      t.text :details

      t.timestamps
    end
  end
end
