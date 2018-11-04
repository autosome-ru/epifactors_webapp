class ProteinComplexesController < ApplicationController
  caches_action :index, unless: ->{ params.has_key? :search }

  def index
    @protein_complexes = ProteinComplex.by_params(params)

    if @protein_complexes.count == 1 && !(params[:redirect] == 'no')
      redirect_to protein_complex_path(@protein_complexes.first.id) and return
    end

    respond_to do |format|
      format.html do
        @protein_complexes = ProteinComplexDecorator.decorate_collection(@protein_complexes)
      end
      format.json{ render json: @protein_complexes.map{|protein_complex| {id: protein_complex.id, complex_name: protein_complex.complex_name} } }
    end
  end
  def show
    @protein_complex = ProteinComplex.find(params[:id])
    respond_to do |format|
      format.html do
        @protein_complex = @protein_complex.decorate
      end
      format.json
    end
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
