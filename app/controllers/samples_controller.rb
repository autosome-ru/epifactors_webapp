class SamplesController < ApplicationController
  def index
    @samples = SampleDecorator.decorate_collection(GeneExpressions.instance.samples)
  end

  def show
    @sample = Sample.find_by_sample_id(params[:id].to_sym)
  end
end
