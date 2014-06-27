class GenesController < ApplicationController
  respond_to :html
  def index
    @genes = Gene.all
    respond_with(@genes)
  end
  def show
    @gene = Gene.find(params[:id])
    respond_with(@gene)
  end
end
