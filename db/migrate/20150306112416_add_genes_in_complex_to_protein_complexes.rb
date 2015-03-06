class AddGenesInComplexToProteinComplexes < ActiveRecord::Migration
  def change
    change_table :protein_complexes do |t|
      # Genes in complex is a gene inclusion pattern automatically created from uniprots inclusion pattern
      # Format is the same as for uniprot pattern but names are <gene>#<id>. For now gene is just hgnc symbol.
      # Id is used to get a gene page link
      t.string  :genes_in_complex
    end
  end
end
