class GeneComplexesController < ApplicationController
  respond_to :html
  def index
    if params[:group_name]
      @gene_complexes = GeneComplex.where("\"group_name\" ILIKE ?", "%#{params[:group_name]}%")
    elsif params[:complex_name]
      @gene_complexes = GeneComplex.where("\"complex_name\" ILIKE ?", "%#{params[:complex_name]}%")
      if @gene_complexes.count == 1
        redirect_to gene_complex_path(@gene_complexes.first.id) and return
      end
    else
      @gene_complexes = GeneComplex.by_word(params[:search])
    end
    @gene_complexes = GeneComplexDecorator.decorate_collection(@gene_complexes)
    respond_with(@gene_complexes)
  end
  def show
    @gene_complex = GeneComplex.find(params[:id])
    @gene_complex = @gene_complex.decorate
    respond_with(@gene_complex)
  end
end
