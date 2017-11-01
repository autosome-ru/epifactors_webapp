class GeneExpressions
  attr_reader :samples, :gene_symbols, :gene_expressions
  attr_reader :quantiles_over_samples, :quantiles_over_genes

  # samples = [sample_1, sample_2,...]
  # gene_expressions = {hgnc_1 => [expression_for_sample_1, expression_for_sample_2,...], ...}
  # hgnc_id should be integer
  # quantiles_over_<...> = {hgnc_1 =>[quantile_for_sample_1, quantile_for_smaple_2,...], ...}

  def initialize(samples, gene_expressions, gene_symbols)
    @samples = samples
    @gene_expressions = gene_expressions
    @gene_symbols = gene_symbols
    @index_of_sample_cache = @samples.map(&:sample_id).each_with_index.to_h

    @quantiles_over_samples = gene_expressions.map{|hgnc_id, expressions_over_samples|
      [hgnc_id.to_i, calculate_quantiles(expressions_over_samples)]
    }.to_h

    gene_hgnc_ids = gene_expressions.keys.sort # any constant order for inner use
    index_of_gene_hgnc_id = gene_hgnc_ids.each_with_index.to_h

    quantiles_over_genes_by_sample_id = samples.map{|sample|
      expressions_over_genes = expressions_by_sample(sample.sample_id).values_at(*gene_hgnc_ids)
      [sample.sample_id, calculate_quantiles(expressions_over_genes)]
    }.to_h

    @quantiles_over_genes = gene_hgnc_ids.map{|hgnc_id|
      gene_index = index_of_gene_hgnc_id[hgnc_id]
      sample_quantiles_for_gene = samples.map{|sample|
        quantiles_over_genes_by_sample_id[sample.sample_id][gene_index]
      }
      [hgnc_id.to_i, sample_quantiles_for_gene]
    }.to_h
  end

  def hgnc_symbol_by_id(hgnc_id)
    @gene_symbols[hgnc_id]
  end

  def expressions_by_hgnc(hgnc_id)
    expressions = @gene_expressions[hgnc_id.to_i]
    expressions ? @samples.zip(expressions).to_h : {}
  end

  def expressions_with_quantiles_by_hgnc(hgnc_id)
    hgnc_id = hgnc_id.to_i
    expressions = @gene_expressions[hgnc_id]
    expressions ? @samples.zip(
                    expressions,
                    quantiles_over_genes[hgnc_id]
                  ) : {}
  end

  def expressions_by_sample(sample_id)
    sample_index = @index_of_sample_cache[sample_id]
    @gene_expressions.map{|hgnc_id, expressions_for_samples|
      [hgnc_id, expressions_for_samples[sample_index]]
    }.to_h
  end

  def expressions_with_quantiles_by_sample(sample_id)
    sample_index = @index_of_sample_cache[sample_id]
    return []  unless sample_index
    @gene_expressions.map{|hgnc_id, expressions_for_samples|
      [ hgnc_id,
        expressions_for_samples[sample_index],
        quantiles_over_samples[hgnc_id][sample_index]
      ]
    }
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

  # quantile of element T is defined as fraction of elements which are strictly less than T
  def calculate_quantiles(arr)
    arr.each_with_index
      .sort_by{|val, ind| val} # ind is an original index (we use it to restore order after all transformations)
      .each_with_index # go by ranks bottom to top (so we can prescribe the lowest of ranks to all same-value elements)
      .inject([]){|result,((val,ind),rank)|
        if result.empty?
          [[val, ind, rank]]
        else
          last_val, last_ind, last_rank = result.last
          if last_val == val
            result + [[val, ind, last_rank]]
          else
            result + [[val, ind, rank]]
          end
        end
      }
      .map{|val, ind, rank| [rank.to_f / arr.size, ind] } # if we go top-to-bottom (<=T criterium), it should be (rank.to_f + 1)/arr.size
      .sort_by{|quantile, ind| ind }
      .map{|quantile, ind| quantile }
  end

  def self.instance
    @instance ||= GeneExpressions.read_from_file( Rails.root.join('public', 'public_data', 'gene_expressions_by_sample.txt') )
  end
end
