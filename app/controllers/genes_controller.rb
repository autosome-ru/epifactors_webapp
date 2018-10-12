class GenesController < ApplicationController
  def index
    @genes = Gene.by_params(params)
    if @genes.count == 1 && !(params[:redirect] == 'no')
      redirect_to gene_path(@genes.first.id) and return
    end

    respond_to do |format|
      format.html do
        @genes = GeneDecorator.decorate_collection(@genes)
      end
      format.json{ render json: @genes.map{|gene| {id: gene.id, hgnc_symbol: gene.hgnc_symbol} } }
    end
  end
  def show
    @gene = Gene.find(params[:id])
    @expressions_with_quantiles = @gene.gene_expressions_with_quantiles
    @expression_statistics = @gene.expression_statistics

    @expression_statistics = StatisticsDecorator.decorate(@expression_statistics)
    respond_to do |format|
      format.html do
        @gene = @gene.decorate
      end
      format.json
    end
  end

protected
  def page_title
    if params[:action].to_sym == :show
      @gene.hgnc_symbol + " gene - " + super
    else
      'Genes - ' + super
    end
  end
end
