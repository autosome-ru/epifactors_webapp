class SamplesController < ApplicationController
  caches_action :index

  def index
    sample_list = GeneExpressions.instance.samples.sort_by{|sample|
      [sample.sample_kind, sample.sample_name]
    }
    @samples = SampleDecorator.decorate_collection(sample_list)
  end

  def show
    @sample = Sample.find_by_sample_id(params[:id].to_sym)
    @sample = SampleDecorator.decorate(@sample)
    gene_expressions = GeneExpressions.instance
    genes_by_hgnc_id = Gene.all.map{|gene| [gene.hgnc_id.to_i, gene] }.to_h
    histones_by_hgnc_id = Histone.all.map{|histone| [histone.hgnc_id.to_i, histone] }.to_h
    sample_expressions_with_quantiles = GeneExpressions.instance.expressions_with_quantiles_by_sample(@sample.sample_id)
    @sample_infos = sample_expressions_with_quantiles.map{|hgnc_id, expression, quantile_over_samples|
      gene_or_histone = (genes_by_hgnc_id[hgnc_id] || histones_by_hgnc_id[hgnc_id]).decorate
      hgnc_symbol = gene_expressions.hgnc_symbol_by_id(hgnc_id)
      [hgnc_id, hgnc_symbol, gene_or_histone, expression, quantile_over_samples]
    }.sort_by{|hgnc_id, hgnc_symbol, gene_or_histone, expression, quantile_over_samples|
      [gene_or_histone.molecule_kind, -expression]
    }
  end
protected
  def page_title
    if params[:action].to_sym == :show
      "Expression in #{@sample} - " + super
    else
      'Samples - ' + super
    end
  end
end
