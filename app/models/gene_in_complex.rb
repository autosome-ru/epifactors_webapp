class GeneInComplex < ActiveRecord::Base
  belongs_to :gene_complex
  belongs_to :gene
end
