class StatisticsDecorator < Draper::Decorator
  delegate_all

  def min; object.min || 'N/A'; end
  def max; object.max || 'N/A'; end
  def mean; object.mean || 'N/A'; end
  def mean_square; object.mean_square || 'N/A'; end
  def variance; object.variance || 'N/A'; end
  def stddev; object.stddev || 'N/A'; end
  def median(round: 2)
    median_val = object.median
    median_val = median_val.round(round)  if round && median_val
    median_val || 'N/A'
  end

  def range(round: 2)
    min = object.min
    max = object.max
    min, max = min.round(round), max.round(round)  if round && min && max
    (object.size > 0) ? "#{min} to #{max}" : 'N/A'
  end

  def mean_with_stddev(round: 2)
    mean = object.mean
    stddev = object.stddev
    mean, stddev = mean.round(round), stddev.round(round)  if round && mean && stddev
    (object.size > 0) ? "#{mean} &pm; #{stddev}".html_safe : 'N/A'
  end
end
