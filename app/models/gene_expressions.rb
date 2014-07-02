class GeneExpressions
  attr_reader :tissues, :gene_expressions
  # tissues = ['Tissue 1', 'Tissue 2',...]
  # gene_expressions = {hgnc_1 => [expression_for_tissue_1, expression_for_tissue_2,...], ...}
  def initialize(tissues, gene_expressions)
    @tissues, @gene_expressions = tissues, gene_expressions
  end

  def expressions_by_hgnc(hgnc_id)
    expressions = gene_expressions[hgnc_id.to_i]
    expressions ? Hash[tissues.zip(expressions)] : {}
  end

  def self.read_from_file(tissue_names_file, gene_expressions_file)
    tissues = File.readlines(tissue_names_file).map(&:strip)
    gene_expressions = {}
    File.readlines(gene_expressions_file).each do |line|
      hgnc_id, *expressions = line.strip.split("\t")
      gene_expressions[hgnc_id.to_i] = expressions.map(&:to_f)
    end
    GeneExpressions.new(tissues, gene_expressions)
  end

  class << self
    attr_accessor :instance
  end
end
