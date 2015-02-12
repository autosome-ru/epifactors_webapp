class GeneExpressions
  attr_reader :samples, :gene_expressions
  # samples = ['Sample 1 name', 'Sample 2 name',...]
  # gene_expressions = {hgnc_1 => [expression_for_sample_1, expression_for_sample_2,...], ...}
  def initialize(samples, gene_expressions)
    @samples, @gene_expressions = samples, gene_expressions
  end

  def expressions_by_hgnc(hgnc_id)
    expressions = gene_expressions[hgnc_id.to_i]
    expressions ? samples.zip(expressions).to_h : {}
  end

  def self.read_from_file(gene_expressions_file)
    samples = nil
    gene_expressions = {}
    File.open(gene_expressions_file) do |f|
      samples = f.readline.chomp.split("\t").drop(2)
      f.each_line do |line|
        hgnc_id, hgnc_symbol, *expressions = line.strip.split("\t")
        gene_expressions[hgnc_id.to_i] = expressions.map(&:to_f)
      end
    end
    GeneExpressions.new(samples, gene_expressions)
  end

  def self.instance
    @instance ||= GeneExpressions.read_from_file( Rails.root.join('public', 'public_data', 'gene_expressions_by_sample.txt') )
  end
end
