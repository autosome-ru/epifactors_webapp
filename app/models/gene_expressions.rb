class GeneExpressions
  SAMPLE_NAME_PATTERN = /^(?<name>.+)\.(?<sample_id>CNhs\w+\.\w+-\w+)$/

  def self.sample_name_by_full_name(full_name)
    full_name.match(SAMPLE_NAME_PATTERN)[:name]
  end

  def self.sample_id_by_full_name(full_name)
    full_name.match(SAMPLE_NAME_PATTERN)[:sample_id]
  end

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

  def index_of_sample_cache
    @index_of_sample_cache ||= samples.each_with_index.to_h
  end

  def expressions_by_sample(sample_id)
    sample_index = index_of_sample_cache[sample_id]
    @gene_expressions.map{|hgnc_id, expressions_for_samples| [hgnc_id, expressions_for_samples[sample_index]] }.to_h
  end

  def sample_by_id_cache
    @sample_by_id_cache ||= @samples.map{|full_name| [GeneExpressions.sample_id_by_full_name(full_name), full_name] }.to_h
  end

  def sample_by_id(id)
    sample_by_id_cache[id]
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
