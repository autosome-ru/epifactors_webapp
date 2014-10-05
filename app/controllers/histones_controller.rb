class HistonesController < ApplicationController
  respond_to :html
  def index
    if params[:target_type]
      @histones = Histone.where("\"uniprot_id\" LIKE ?", "#{params[:target_type]}%")
    else
      @histones = Histone.by_word(params[:search])
    end
    @histones = HistoneDecorator.decorate_collection(@histones)
    respond_with(@histones)
  end
  def show
    @histone = Histone.find(params[:id])
    @expressions = @histone.gene_expressions
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
