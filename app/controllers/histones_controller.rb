class HistonesController < ApplicationController
  respond_to :html
  def index
    @histones = Histone.by_params(params)

    if @histones.count == 1 && !(params[:redirect] == 'no')
      redirect_to histone_path(@histones.first.id) and return
    end

    @histones = HistoneDecorator.decorate_collection(@histones)
    respond_with(@histones)
  end
  def show
    @histone = Histone.find(params[:id])
    @expressions_with_quantiles = @histone.gene_expressions_with_quantiles
    @expression_statistics = @histone.expression_statistics

    @expression_statistics = StatisticsDecorator.decorate(@expression_statistics)
    @histone = @histone.decorate
    respond_with(@histone)
  end
protected
  def page_title
    if params[:action].to_sym == :show
      @histone.hgnc_symbol + " #{@histone.molecule_kind} - " + super
    else
      'Histones and protamines - ' + super
    end
  end
end
