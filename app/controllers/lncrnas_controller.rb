class LncrnasController < ApplicationController
  caches_action :index, unless: ->{ params.has_key? :search }
  
  def index
    @lncrnas = Lncrna.by_params(params).sort_by(&:hgnc_symbol)
    if @lncrnas.count == 1 && !(params[:redirect] == 'no')
      lncrna = @lncrnas.first
      if lncrna.hgnc_symbol
        redirect_to lncrna_by_hgnc_path(lncrna.hgnc_symbol) and return
      else
        redirect_to lncrna_path(lncrna.id) and return
      end
    end
    respond_to do |format|
      format.html do
        @lncrnas = LncrnaDecorator.decorate_collection(@lncrnas)
      end
      format.json{ render json: @lncrnas.map{|lncrna| {id: lncrna.id, hgnc_symbol: lncrna.hgnc_symbol} } }
    end
  end

  def show
    lncrna = Lncrna.find(params[:id])
    if lncrna.hgnc_symbol
      respond_to do |format|
        format.html { redirect_to lncrna_by_hgnc_path(lncrna.hgnc_symbol) }
        format.json { redirect_to lncrna_by_hgnc_path(lncrna.hgnc_symbol, format: :json) }
      end
    else
      show_lncrna lncrna
    end
  end

  def show_by_hgnc
    show_lncrna Lncrna.where(hgnc_symbol: params[:hgnc_symbol]).first
  end

protected

  def show_lncrna(lncrna)
    @lncrna = lncrna
    @expressions_with_quantiles = @lncrna.gene_expressions_with_quantiles.sort_by{|sample, expression, quantile_over_genes|
      [sample.sample_kind, -expression]
    }
    @expression_statistics = @lncrna.expression_statistics

    @expression_statistics = StatisticsDecorator.decorate(@expression_statistics)
    respond_to do |format|
      format.html do
        @lncrna = @lncrna.decorate
        render :show
      end
      format.json{ render :show }
    end
  end

  def page_title
    if params[:action].to_sym == :show
      @lncrna.hgnc_symbol + " lncRNA - " + super
    else
      'lncRNAs - ' + super
    end
  end
end
