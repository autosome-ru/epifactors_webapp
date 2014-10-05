class ProteinComplexesController < ApplicationController
  respond_to :html
  def index
    if params[:group_name]
      @protein_complexes = ProteinComplex.where("\"group_name\" LIKE ?", "%#{params[:group_name]}%")
    elsif params[:complex_name]
      @protein_complexes = ProteinComplex.where("\"complex_name\" LIKE ?", "%#{params[:complex_name]}%")
      if @protein_complexes.count == 1
        redirect_to protein_complex_path(@protein_complexes.first.id) and return
      end
    else
      @protein_complexes = ProteinComplex.by_word(params[:search])
    end
    @protein_complexes = @protein_complexes.includes(:genes)
    @protein_complexes = ProteinComplexDecorator.decorate_collection(@protein_complexes)
    respond_with(@protein_complexes)
  end
  def show
    @protein_complex = ProteinComplex.find(params[:id])
    @protein_complex = @protein_complex.decorate
    respond_with(@protein_complex)
  end
end
