require 'rubyXL'

def extract_worksheet_data(worksheet, column_order)
  worksheet.extract_data.drop(1).map {|row|
    column_order.each_with_index.map {|column_name, column_index|
      cell_data = row[column_index]
      cell_data = cell_data.strip  if cell_data.respond_to?(:strip)
      [column_name, cell_data]
    }.to_h
  }
end

EPIGENES_COLUMNS_ORDER =  [
  :id,
  :hgnc_symbol, :status, :hgnc_id, :hgnc_name, :gene_id, :uniprot_ac, :uniprot_id, :domain, :mgi_symbol,
  :mgi_id, :uniprot_ac_mm, :uniprot_id_mm, :gene_tag, :gene_desc, :function, :modification, :pmid_function,
  :complex_name, :target, :specific_target, :product, :uniprot_id_target, :pmid_target, :comment
]

PROTEIN_COMPLEXES_COLUMNS_ORDER =  [
  :id,
  :group, :group_name, :complex_name, :status, :alternative_name, :protein, :uniprot_id, :pmid_complex,
  :function, :pmid_function, :target, :specific_target, :product, :uniprot_id_target, :pmid_target, :comment
]

HISTONES_COLUMNS_ORDER =  [
  :id,
  :hgnc_symbol, :status, :hgnc_id, :hgnc_name, :gene_id, :uniprot_ac, :uniprot_id, :domain,
  :mgi_symbol, :mgi_id, :uniprot_ac_mm, :uniprot_id_mm, :gene_tag, :gene_desc, :complex_name,
  :targeted_by_protein, :targeted_by_complex, :pmid, :comment
]


epigenes_worksheet = RubyXL::Parser.parse(Rails.root.join('public', 'public_data', 'v1.6', 'EpiGenes_main_1_6.xlsx')).worksheets[0]
protein_complexes_worksheet = RubyXL::Parser.parse(Rails.root.join('public', 'public_data', 'v1.6', 'EpiGenes_complexes_1_6.xlsx')).worksheets[0]
histones_worksheet = RubyXL::Parser.parse(Rails.root.join('public', 'public_data', 'v1.6', 'EpiGenes_histones_1_6.xlsx')).worksheets[0]

namespace :data do
  desc 'Load all data from excel files into DB'
  task :load_excel_to_db => ['load_excel_to_db:epigenes', 'load_excel_to_db:protein_complex', 'load_excel_to_db:histones']
  
  namespace :load_excel_to_db do
    desc 'Load epigenes from xlsx-file into database'
    task :epigenes => [:environment, epigenes_worksheet] do
      epigenes = extract_worksheet_data(epigenes_worksheet, EPIGENES_COLUMNS_ORDER)
      Gene.delete_all
      epigenes.each do |epigene_info|
        Gene.create!( epigene_info )
      end
    end

    desc 'Load protein complex from xlsx-file into database'
    task :protein_complex => [:environment, protein_complexes_worksheet, :epigenes] do
      protein_complexes = extract_worksheet_data(protein_complexes_worksheet, PROTEIN_COMPLEXES_COLUMNS_ORDER)
      ProteinComplex.delete_all
      protein_complexes.each do |protein_complex_info|
        ProteinComplex.create!( protein_complex_info )
      end

      # cache protein complex's gene inclusion pattern
      ProteinComplex.find_each do |protein_complex|
        protein_complex.genes_in_complex = protein_complex.involved_genes.map{|gene| "#{gene.to_s}##{gene.id}" }.to_s
        protein_complex.save
      end
    end

    desc 'Load histones from xlsx-file into database'
    task :histones => [:environment, histones_worksheet] do
      histones = extract_worksheet_data(histones_worksheet, HISTONES_COLUMNS_ORDER)
      histones.each do |histone_info|
        Histone.create!( histone_info )
      end
    end
  end
end
