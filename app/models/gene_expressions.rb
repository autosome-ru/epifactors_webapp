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

  # def self.read_from_file(tissue_names_file, gene_expressions_file)
  def self.read_from_file(gene_expressions_file)
    # tissues = File.readlines(tissue_names_file).map(&:strip)
    tissues = nil
    gene_expressions = {}
    File.open(gene_expressions_file) do |f|
      tissues = f.readline.chomp.split("\t").drop(2)
      f.each_line do |line|
        hgnc_id, hgnc_symbol, *expressions = line.strip.split("\t")
        gene_expressions[hgnc_id.to_i] = expressions.map(&:to_f)
      end
    end
    GeneExpressions.new(tissues, gene_expressions)
  end

  def self.instance
    @instance ||= GeneExpressions.read_from_file( Rails.root.join('public', 'public_data', 'gene_expressions_by_tissue.txt') )
  end
end
