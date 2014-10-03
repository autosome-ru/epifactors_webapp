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
    @expressions = GeneExpressions.instance.expressions_by_hgnc(@histone.hgnc_id)
    @expression_statistics = Statistics.new(@expressions.map{|k,v| v })

    @expression_statistics = StatisticsDecorator.decorate(@expression_statistics)
    @histone = @histone.decorate
    respond_with(@histone)
  end
end
