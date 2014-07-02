class StatisticsDecorator < Draper::Decorator
  delegate_all

  def min; object.min || 'N/A'; end
  def max; object.max || 'N/A'; end
  def mean; object.mean || 'N/A'; end
  def mean_square; object.mean_square || 'N/A'; end
  def variance; object.variance || 'N/A'; end
  def stddev; object.stddev || 'N/A'; end
  def median; object.median || 'N/A'; end

  def range
    "#{object.min} to #{object.max}"
  end
  def mean_with_stddev
    "#{object.mean} &pm; #{object.stddev}".html_safe
  end
end
