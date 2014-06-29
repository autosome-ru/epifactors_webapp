class Statistics
  attr_reader :values

  def initialize(values)
    @values = values
  end

  def size
    values.size
  end

  def sorted_values
    values.sort
  end
  
  def median
    sorted_values[size / 2]
  end
  
  def mean
    values.inject(0.0, &:+) / size
  end
  
  def mean_square
    values.map{|x| x**2}.inject(0.0, &:+) / size
  end
  
  def variance
    mean_square - mean**2
  end
  
  def stddev
    Math.sqrt((size / (size - 1.0)) * variance)
  end

  def min
    values.min
  end

  def max
    values.max
  end
end
