class CreateGeneInComplexes < ActiveRecord::Migration
  def change
    create_table :gene_in_complexes do |t|
      t.references :protein_complex, index: true
      t.references :gene, index: true

      t.timestamps
    end
  end
end
