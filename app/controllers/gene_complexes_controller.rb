class GeneComplexesController < ApplicationController
  respond_to :html
  def index
    @gene_complexes = GeneComplex.by_word(params[:search])
    respond_with(@gene_complexes)
  end
  def show
    @gene_complex = GeneComplex.find(params[:id])
    respond_with(@gene_complex)
  end
end
