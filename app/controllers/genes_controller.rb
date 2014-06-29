class GenesController < ApplicationController
  respond_to :html
  def index
    @genes = Gene.by_word(params[:search])
    respond_with(@genes)
  end
  def show
    @gene = Gene.find(params[:id])
    GeneExpressions.instance ||= GeneExpressions.read_from_file(Rails.root.join('db','tissue_names.txt'), 
                                                                Rails.root.join('db','gene_expressions_by_tissue.txt'))
    @expressions = GeneExpressions.instance.expressions_by_hgnc(@gene.hgnc_id)

    @expression_statistics = Statistics.new(@expressions.map{|k,v| v })

    respond_with(@gene)
  end
end
