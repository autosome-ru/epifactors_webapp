class HistonesController < ApplicationController
  caches_action :index, unless: ->{ params.has_key? :search }

  def index
    @histones = Histone.by_params(params).sort_by(&:hgnc_symbol)

    if @histones.count == 1 && !(params[:redirect] == 'no')
      redirect_to histone_path(@histones.first.id) and return
    end

    respond_to do |format|
      format.html do
        @histones = HistoneDecorator.decorate_collection(@histones)
      end
      format.json{ render json: @histones.map{|histone| {id: histone.id, hgnc_symbol: histone.hgnc_symbol} } }
    end
  end
  def show
    @histone = Histone.find(params[:id])
    @expressions_with_quantiles = @histone.gene_expressions_with_quantiles.sort_by{|sample, expression, quantile_over_genes|
      [sample.sample_kind, -expression]
    }
    @expression_statistics = @histone.expression_statistics

    @expression_statistics = StatisticsDecorator.decorate(@expression_statistics)
    respond_to do |format|
      format.html do
        @histone = @histone.decorate
      end
      format.json
    end

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
