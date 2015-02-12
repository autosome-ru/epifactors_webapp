class SamplesController < ApplicationController
  def index
    @samples = SampleDecorator.decorate_collection(GeneExpressions.instance.samples)
  end

  def show
    @sample = GeneExpressions.instance.sample_by_id(params[:id])
  end
end
