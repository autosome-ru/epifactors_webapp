class GeneComplexesController < ApplicationController
  respond_to :html
  def index
    @gene_complexes = GeneComplex.by_word(params[:search])
    @gene_complexes = GeneComplexDecorator.decorate_collection(@gene_complexes)
    respond_with(@gene_complexes)
  end
  def show
    @gene_complex = GeneComplex.find(params[:id])
    @gene_complex = @gene_complex.decorate
    respond_with(@gene_complex)
  end
end
