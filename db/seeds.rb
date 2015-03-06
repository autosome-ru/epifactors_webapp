# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'cgi'
require 'set'
require 'rubyXL'

EPIGENES_COLUMNS_ORDER =  [
  :hgnc_symbol, :status, :hgnc_id, :hgnc_name, :gene_id, :uniprot_ac, :uniprot_id, :domain, :mgi_symbol,
  :mgi_id, :uniprot_ac_mm, :uniprot_id_mm, :gene_tag, :gene_desc, :function, :modification, :pmid_function,
  :complex_name, :target, :specific_target, :product, :uniprot_id_target, :pmid_target, :comment
]



PROTEIN_COMPLEXES_COLUMNS_ORDER =  [
  :group, :group_name, :complex_name, :status, :alternative_name, :protein, :uniprot_id, :pmid_complex,
  :function, :pmid_function, :target, :specific_target, :product, :uniprot_id_target, :pmid_target, :comment
]

HISTONES_COLUMNS_ORDER =  [
  :hgnc_symbol, :status, :hgnc_id, :hgnc_name, :gene_id, :uniprot_ac, :uniprot_id, :domain,
  :mgi_symbol, :mgi_id, :uniprot_ac_mm, :uniprot_id_mm, :gene_tag, :gene_desc, :complex_name,
  :targeted_by_protein, :targeted_by_complex, :pmid, :comment
]

def extract_worksheet_data(worksheet, column_order)
  worksheet.extract_data.drop(1).map {|row|
    column_order.each_with_index.map {|column_name, column_index|
      cell_data = row[column_index]
      cell_data = cell_data.strip  if cell_data.respond_to?(:strip)
      [column_name, cell_data]
    }.to_h
  }
end

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

$stderr.puts 'Reading XLSes...'
epigenes_worksheet = RubyXL::Parser.parse(Rails.root.join('public', 'public_data', 'v1.6', 'EpiGenes_main_1_6.xlsx')).worksheets[0]
protein_complexes_worksheet = RubyXL::Parser.parse(Rails.root.join('public', 'public_data', 'v1.6', 'EpiGenes_complexes_1_6.xlsx')).worksheets[0]
histones_worksheet = RubyXL::Parser.parse(Rails.root.join('public', 'public_data', 'v1.6', 'EpiGenes_histones_1_6.xlsx')).worksheets[0]

$stderr.puts 'Extracting worksheet data...'
epigenes = extract_worksheet_data(epigenes_worksheet, EPIGENES_COLUMNS_ORDER)
protein_complexes = extract_worksheet_data(protein_complexes_worksheet, PROTEIN_COMPLEXES_COLUMNS_ORDER)
histones = extract_worksheet_data(histones_worksheet, HISTONES_COLUMNS_ORDER)

$stderr.puts 'Extracting epigenes...'
epigenes.each_with_index do |epigene_info, ind|
  Gene.where(id: ind + 1).first_or_create!( epigene_info )
end

$stderr.puts 'Extracting protein complexes...'
protein_complexes.each_with_index do |protein_complex_info, ind|
  ProteinComplex.where(id: ind + 1).first_or_create!( protein_complex_info )
end

$stderr.puts 'Extracting histones...'
histones.each_with_index do |histone_info, ind|
  Histone.where(id: ind + 1).first_or_create!( histone_info )
end

ProteinComplex.find_each do |protein_complex|
  Gene.where(uniprot_id: protein_complex.uniprot_ids_splitted).find_each do |gene|
    GeneInComplex.where(gene_id: gene.id, protein_complex_id: protein_complex.id).first_or_create!
  end
end

# cache protein complex's gene inclusion pattern
ProteinComplex.find_each do |protein_complex|
  protein_complex.genes_in_complex = protein_complex.involved_genes.map{|gene| "#{gene.to_s}##{gene.id}" }.to_s
  protein_complex.save
end

{ '/home/ilya/iogen/cages/hg19/robust_phase1_pls_2.tpm.desc121113.osc.txt' => Rails.root.join('public', 'public_data', 'gene_expressions_by_sample_with_timecourses.txt'),
  '/home/ilya/iogen/cages/hg19/freeze1/hg19.cage_peak_tpm_ann.osc.txt' => Rails.root.join('public', 'public_data', 'gene_expressions_by_sample.txt')
}.each do |tpm_filename, sample_expressions_file|
  if File.exist?(sample_expressions_file)
    $stderr.puts "Skipping gene expressions (#{tpm_filename} --> #{sample_expressions_file})..."
  else
    $stderr.puts "Extracting gene expressions (#{tpm_filename} --> #{sample_expressions_file})..."
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
end
