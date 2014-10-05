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
  :mgi_id, :uniprot_ac_mm, :uniprot_id_mm, :gene_tag, :gene_desc, :functional_class, :function, :pmid_function,
  :complex_name, :target, :specific_target, :product, :uniprot_id_target, :pmid_target, :comment
]



GENE_COMPLEXES_COLUMNS_ORDER =  [
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
    column_order.each_with_index.map {|column_name, column_index| [column_name, row[column_index]] }.to_h
  }
end

def tissue_names_from_peaks_file(tpm_filename)
  tissue_names = []
  tissue_name_pattern = /##ColumnVariables\[tpm\.(?<tissue_name>.+)\]=/

  File.open(tpm_filename) do |f|
    f.each_line do |line|
      if match = line.match( tissue_name_pattern )
        tissue_name = CGI.unescape(match[:tissue_name])
        tissue_names << tissue_name
      end
    end
  end
  tissue_names
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
epigenes_worksheet = RubyXL::Parser.parse(Rails.root.join('db', 'data', 'EpiGenes_main_1_5.xlsx')).worksheets[0]
complexes_worksheet = RubyXL::Parser.parse(Rails.root.join('db', 'data', 'EpiGenes_complexes_1_5.xlsx')).worksheets[0]
histones_worksheet = RubyXL::Parser.parse(Rails.root.join('db', 'data', 'EpiGenes_histones_1_5.xlsx')).worksheets[0]

$stderr.puts 'Extracting worksheet data...'
epigenes = extract_worksheet_data(epigenes_worksheet, EPIGENES_COLUMNS_ORDER)
gene_complexes = extract_worksheet_data(complexes_worksheet, GENE_COMPLEXES_COLUMNS_ORDER)
histones = extract_worksheet_data(histones_worksheet, HISTONES_COLUMNS_ORDER)

$stderr.puts 'Extracting epigenes...'
epigenes.each_with_index do |epigene_info, ind|
  Gene.where(id: ind + 1).first_or_create!( epigene_info )
end

$stderr.puts 'Extracting gene complexes...'
gene_complexes.each_with_index do |gene_complex_info, ind|
  GeneComplex.where(id: ind + 1).first_or_create!( gene_complex_info )
end

$stderr.puts 'Extracting histones...'
histones.each_with_index do |histone_info, ind|
  Histone.where(id: ind + 1).first_or_create!( histone_info )
end

GeneComplex.find_each do |gene_complex|
  Gene.where(uniprot_id: gene_complex.uniprot_ids_splitted).find_each do |gene|
    GeneInComplex.where(gene_id: gene.id, gene_complex_id: gene_complex.id).first_or_create!
  end
end

{ '/home/ilya/iogen/cages/hg19/robust_phase1_pls_2.tpm.desc121113.osc.txt' => Rails.root.join('db', 'data', 'gene_expressions_by_tissue_with_timecourses.txt'),
  '/home/ilya/iogen/cages/hg19/freeze1/hg19.cage_peak_tpm_ann.osc.txt' => Rails.root.join('db', 'data', 'gene_expressions_by_tissue.txt')
}.each do |tpm_filename, tissue_expressions_file|
  if File.exist?(tissue_expressions_file)
    $stderr.puts "Skipping gene expressions (#{tpm_filename} --> #{tissue_expressions_file})..."
  else
    $stderr.puts "Extracting gene expressions (#{tpm_filename} --> #{tissue_expressions_file})..."
    hgnc_symbols = {}
    epigenes.select{|info| info[:hgnc_id] && info[:hgnc_id] != '-' }.each{|info| hgnc_symbols[info[:hgnc_id]] = info[:hgnc_symbol] }
    histones.select{|info| info[:hgnc_id] && info[:hgnc_id] != '-' }.each{|info| hgnc_symbols[info[:hgnc_id]] = info[:hgnc_symbol] }
    target_hgnc_ids = Set.new(hgnc_symbols.keys)

    tissue_names = tissue_names_from_peaks_file(tpm_filename)
    gene_expressions = gene_expressions_from_peaks_file(tpm_filename, target_hgnc_ids)

    File.open(tissue_expressions_file, 'w') do |fw|
      fw.puts ['HGNC ID', 'HGNC symbol', *tissue_names].join("\t")
      gene_expressions.each do |gene, gene_expressions_by_tissue|
        fw.puts [gene, hgnc_symbols[gene], *gene_expressions_by_tissue].join("\t")
      end
    end
  end
end
