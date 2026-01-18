class EpifactorsController < ApplicationController
  def index
  end

  def description_queries
  end

  def description
  end

  def search
    case params[:kind]
    when 'genes'
      redirect_to genes_path(search: params[:search])
    when 'protein_complexes'
      redirect_to protein_complexes_path(search: params[:search])
    when 'histones'
      redirect_to histones_path(search: params[:search])
    when 'lncrnas'
      redirect_to lncrnas_path(search: params[:search])
    end
  end
end
