class GenesController < ApplicationController
  respond_to :html
  def index
    @genes = Gene.by_params(params)
    if @genes.count == 1 && !(params[:redirect] == 'no')
      redirect_to gene_path(@genes.first.id) and return
    end

    @genes = GeneDecorator.decorate_collection(@genes)
    respond_with(@genes)
  end
  def show
    @gene = Gene.find(params[:id])
    @expressions_with_quantiles = @gene.gene_expressions_with_quantiles
    @expression_statistics = @gene.expression_statistics

    @expression_statistics = StatisticsDecorator.decorate(@expression_statistics)
    @gene = @gene.decorate
    respond_with(@gene)
  end

protected
  def page_title
    'Genes - ' + super
  end
  def page_title
    if params[:action].to_sym == :show
      @gene.hgnc_symbol + " gene - " + super
    else
      'Genes - ' + super
    end
  end
end
