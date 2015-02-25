class GeneExpressions
  attr_reader :samples, :gene_symbols, :gene_expressions

  # samples = [sample_1, sample_2,...]
  # gene_expressions = {hgnc_1 => [expression_for_sample_1, expression_for_sample_2,...], ...}
  # hgnc_id should be integer
  def initialize(samples, gene_expressions, gene_symbols)
    @samples = samples
    @gene_expressions = gene_expressions
    @gene_symbols = gene_symbols
    @index_of_sample_cache = @samples.map(&:sample_id).each_with_index.to_h
  end

  def hgnc_symbol_by_id(hgnc_id)
    @gene_symbols[hgnc_id]
  end

  def expressions_by_hgnc(hgnc_id)
    expressions = @gene_expressions[hgnc_id.to_i]
    expressions ? @samples.zip(expressions).to_h : {}
  end

  def expressions_by_sample(sample_id)
    sample_index = @index_of_sample_cache[sample_id]
    @gene_expressions.map{|hgnc_id, expressions_for_samples| [hgnc_id, expressions_for_samples[sample_index]] }.to_h
  end

  def self.read_from_file(gene_expressions_file)
    samples = nil
    gene_expressions = {}
    gene_symbols = {}
    File.open(gene_expressions_file) do |f|
      samples = f.readline.chomp.split("\t").drop(2).map{|name| Sample.find_by_full_name(name) }
      f.each_line do |line|
        hgnc_id, hgnc_symbol, *expressions = line.strip.split("\t")
        gene_expressions[hgnc_id.to_i] = expressions.map(&:to_f)
        gene_symbols[hgnc_id.to_i] = hgnc_symbol
      end
    end
    GeneExpressions.new(samples, gene_expressions, gene_symbols)
  end

  def self.instance
    @instance ||= GeneExpressions.read_from_file( Rails.root.join('public', 'public_data', 'gene_expressions_by_sample.txt') )
  end
end
