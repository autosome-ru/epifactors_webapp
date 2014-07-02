class EpigeneWelcomeController < ApplicationController
  def index
  end

  def search
    case params[:kind]
    when 'genes'
      redirect_to genes_path(search: params[:search])
    when 'gene_complexes'
      redirect_to gene_complexes_path(search: params[:search])
    when 'histones'
      redirect_to histones_path(search: params[:search])
    end
  end
end
