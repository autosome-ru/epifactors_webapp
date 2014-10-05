class GenesController < ApplicationController
  respond_to :html
  def index
    @genes = Gene.by_word(params[:search])
    @genes = GeneDecorator.decorate_collection(@genes)
    respond_with(@genes)
  end
  def show
    @gene = Gene.find(params[:id])
    @expressions = @gene.gene_expressions
    @expression_statistics = @gene.expression_statistics

    @expression_statistics = StatisticsDecorator.decorate(@expression_statistics)
    @gene = @gene.decorate
    respond_with(@gene)
  end
end
