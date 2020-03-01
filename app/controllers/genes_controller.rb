class GenesController < ApplicationController
  caches_action :index, unless: ->{ params.has_key? :search }

  def index
    @genes = Gene.by_params(params).sort_by(&:hgnc_symbol)
    if @genes.count == 1 && !(params[:redirect] == 'no')
      gene = @genes.first
      if gene.hgnc_symbol
        redirect_to gene_by_hgnc_path(gene.hgnc_symbol) and return
      else
        redirect_to gene_path(gene.id) and return
      end
    end

    respond_to do |format|
      format.html do
        @genes = GeneDecorator.decorate_collection(@genes)
      end
      format.json{ render json: @genes.map{|gene| {id: gene.id, hgnc_symbol: gene.hgnc_symbol} } }
    end
  end

  def show
    gene = Gene.find(params[:id])
    if gene.hgnc_symbol
      respond_to do |format|
        format.html { redirect_to gene_by_hgnc_path(gene.hgnc_symbol) }
        format.json { redirect_to gene_by_hgnc_path(gene.hgnc_symbol, format: :json) }
      end
    else
      show_gene gene
    end
  end

  def show_by_hgnc
    show_gene Gene.where(hgnc_symbol: params[:hgnc_symbol]).first
  end

protected

  def show_gene(gene)
    @gene = gene
    @expressions_with_quantiles = @gene.gene_expressions_with_quantiles.sort_by{|sample, expression, quantile_over_genes|
      [sample.sample_kind, -expression]
    }
    @expression_statistics = @gene.expression_statistics

    @expression_statistics = StatisticsDecorator.decorate(@expression_statistics)
    respond_to do |format|
      format.html do
        @gene = @gene.decorate
        render :show
      end
      format.json{ render :show }
    end
  end

  def page_title
    if params[:action].to_sym == :show
      @gene.hgnc_symbol + " gene - " + super
    else
      'Genes - ' + super
    end
  end
end
