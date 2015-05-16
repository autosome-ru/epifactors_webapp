class SamplesController < ApplicationController
  def index
    @samples = SampleDecorator.decorate_collection(GeneExpressions.instance.samples)
  end

  def show
    @sample = Sample.find_by_sample_id(params[:id].to_sym)
    @gene_expressions = GeneExpressions.instance
    @sample_expressions_with_percentiles = GeneExpressions.instance.expressions_with_percentiles_by_sample(@sample.sample_id)
    @genes_by_hgnc_id = Gene.all.map{|gene| [gene.hgnc_id.to_i, gene] }.to_h
    @histones_by_hgnc_id = Histone.all.map{|histone| [histone.hgnc_id.to_i, histone] }.to_h
    @sample = SampleDecorator.decorate(@sample)
  end
end
