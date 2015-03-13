class ProteinComplexesController < ApplicationController
  respond_to :html
  def index
    @protein_complexes = ProteinComplex.by_params(params)

    if @protein_complexes.count == 1 && !(params[:redirect] == 'no')
      redirect_to protein_complex_path(@protein_complexes.first.id) and return
    end

    @protein_complexes = ProteinComplexDecorator.decorate_collection(@protein_complexes)
    respond_with(@protein_complexes)
  end
  def show
    @protein_complex = ProteinComplex.find(params[:id])
    @protein_complex = @protein_complex.decorate
    respond_with(@protein_complex)
  end
protected
  def page_title
    if params[:action].to_sym == :show
      @protein_complex.complex_name + ' complex - ' + super
    else
      'Complexes - ' + super
    end
  end
end
