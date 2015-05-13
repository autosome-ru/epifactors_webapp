require 'cgi'
require 'set'

def sample_names_from_peaks_file(tpm_filename)
  sample_names = []
  sample_name_pattern = /##ColumnVariables\[tpm\.(?<sample_name>.+)\]=/

  File.open(tpm_filename) do |f|
    f.each_line do |line|
      if match = line.match( sample_name_pattern )
        sample_name = CGI.unescape(match[:sample_name])
        sample_names << sample_name
      end
    end
  end
  sample_names
end


def gene_expressions_from_peaks_file(tpm_filename, target_hgnc_ids)
  gene_expressions = {} # Hash.new{|hsh, hgnc_id| hsh[hgnc_id] = [] }
  hgnc_pattern = /^HGNC:(?<hgnc>\d+)$/

  File.open(tpm_filename) do |f|
    f.each_line do |line|
      next  unless line.start_with? 'chr'
      $stderr.puts "Line #{f.lineno} "  if f.lineno % 10000 == 0
      
      row = line.strip.split("\t")
      anno, short_dsc, dsc, assoc, entrez, hgnc, uniprot = row.first(7)
      hgnc_ids = hgnc.split(',').map{|hgnc_term| hgnc_term.match(hgnc_pattern) }.map{|match| match && match[:hgnc] }.compact.map(&:to_i)

      next unless Set.new(hgnc_ids).intersect?(target_hgnc_ids)

      # $stderr.puts "#{hgnc_ids.map{|hg| hgnc_symbols[hg] || hg}.join(',')} --> #{Set.new(hgnc_ids).intersection(target_hgnc_ids).to_a.map{|hg| hgnc_symbols[hg]}.join(',')}" if hgnc_ids.size > 1 

      peak_expressions = row.drop(7).map(&:to_f)

      hgnc_ids.each do |hgnc_id|
        next unless target_hgnc_ids.include?(hgnc_id)
        
        gene_expressions[hgnc_id] ||= Array.new(peak_expressions.size, 0)
        peak_expressions.each_with_index do |peak_expression, idx|
          gene_expressions[hgnc_id][idx] += peak_expression
        end
      end
    end
  end
  gene_expressions
end

def extract_gene_expression_into_file(from_filename, to_filename)
  hgnc_symbols = {}
  epigenes.select{|info| info[:hgnc_id] && info[:hgnc_id] != '-' }.each{|info| hgnc_symbols[info[:hgnc_id]] = info[:hgnc_symbol] }
  histones.select{|info| info[:hgnc_id] && info[:hgnc_id] != '-' }.each{|info| hgnc_symbols[info[:hgnc_id]] = info[:hgnc_symbol] }
  target_hgnc_ids = Set.new(hgnc_symbols.keys)

  sample_names = sample_names_from_peaks_file(tpm_filename)
  gene_expressions = gene_expressions_from_peaks_file(tpm_filename, target_hgnc_ids)

  File.open(sample_expressions_file, 'w') do |fw|
    fw.puts ['HGNC ID', 'HGNC symbol', *sample_names].join("\t")
    gene_expressions.each do |gene, gene_expressions_by_sample|
      fw.puts [gene, hgnc_symbols[gene], *gene_expressions_by_sample].join("\t")
    end
  end
end

namespace :data do
  desc 'Load gene expressions by samples'
  task :load_expressions => ['load_expressions:with_timecourses', 'load_expressions:without_timecourses']

  namespace :load_expressions do
    desc 'Load gene expressions by samples (with timecourses)'
    task :with_timecourses => [Rails.root.join('public', 'public_data', 'gene_expressions_by_sample_with_timecourses.txt')]

    desc 'Load gene expressions by samples (without timecourses)'
    task :without_timecourses => [Rails.root.join('public', 'public_data', 'gene_expressions_by_sample.txt')]

    { '/home/ilya/iogen/cages/hg19/robust_phase1_pls_2.tpm.desc121113.osc.txt' => Rails.root.join('public', 'public_data', 'gene_expressions_by_sample_with_timecourses.txt'),
      '/home/ilya/iogen/cages/hg19/freeze1/hg19.cage_peak_tpm_ann.osc.txt' => Rails.root.join('public', 'public_data', 'gene_expressions_by_sample.txt')
    }.each do |tpm_filename, sample_expressions_file|
      file sample_expressions_file => [tpm_filename] do |t|
        extract_gene_expression_into_file(t.prerequisites.first, t.name)
      end
    end
  end
end
