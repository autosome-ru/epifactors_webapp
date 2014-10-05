class GeneInComplex < ActiveRecord::Base
  belongs_to :protein_complex
  belongs_to :gene
end
