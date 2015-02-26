# For now it cannot handle recursive patterns (we don't have some, so it is not a problem).
#
# We suppose pattern (All) to consist of one-or-more comma-separated subpatterns.
# Each subpattern is a simple term (Term) or
# an alternative of subpatterns (Any) or
# a subpattern taken any number of times (Multiple) or
# a subpattern which can be taken optionally (Optional)
module ComplexPattern
  Term = Struct.new(:element) do
    def to_s
      element.to_s
    end
    def map(&block)
      block.call(element)
    end
  end

  Optional = Struct.new(:element) do
    def to_s
      element.to_s + '?'
    end

    def map(&block)
      Optional.new(element.map(&block))
    end
  end

  Multiple = Struct.new(:element) do
    def to_s
      element.to_s + '+'
    end

    def map(&block)
      Multiple.new(element.map(&block))
    end
  end

  Any = Struct.new(:list) do
    def to_s
      '(' + list.map(&:to_s).join('|') + ')'
    end
    def map(&block)
      Any.new(list.map{|term| term.map(&block) }.compact)
    end
  end

  All = Struct.new(:list) do
    def to_s
      list.map(&:to_s).join(', ')
    end

    def map(&block)
      All.new(list.map{|term| term.map(&block)}.compact )
    end
  end

  def self.single_term_from_string(str)
    if str[-1] == '+'
      Multiple.new( ComplexPattern.from_string(str[0..-2]) )
    elsif str[-1] == '?'
      Optional.new( ComplexPattern.from_string(str[0..-2]) )
    elsif str[0] == '(' && str[-1] == ')'
      Any.new( str[1..-2].split('|').map(&:strip).map{|term| ComplexPattern.from_string(term) } )
    else
      Term.new(str)
    end
  end

  def self.from_string(str)
    terms = str.split(',')
    All.new( terms.map{|term| ComplexPattern.single_term_from_string(term.strip) } )
  end
end
