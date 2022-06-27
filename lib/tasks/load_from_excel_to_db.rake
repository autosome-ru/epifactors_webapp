require 'rubyXL'

def extract_worksheet_data(worksheet, column_order)
  worksheet.drop(1).reject(&:nil?).map{|row|
    column_order.each_with_index.map{|column_name, column_index|
      cell_data = row[column_index] && row[column_index].value
      cell_data = cell_data.strip  if cell_data.respond_to?(:strip)
      [column_name, cell_data]
    }.to_h
  }.reject{|hsh|
    hsh.each_value.all?(&:nil?)
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

LNCRNAS_COLUMNS_ORDER =  [
  :id,
  :hgnc_symbol, :status, :hgnc_id, :alternative_names, :hgnc_name, :gene_id, :gene_tag, :gene_desc, :function, :pmid_function,
  :target, :specific_target, :uniprot_id_target, :pmid_target, :comment
]

epigenes_filename = 'public/public_data/current/EpiGenes_main.xlsx'
protein_complexes_filename = 'public/public_data/current/EpiGenes_complexes.xlsx'
histones_filename = 'public/public_data/current/EpiGenes_histones.xlsx'
lncrnas_filename = 'public/public_data/current/EpiGenes_lncrnas.xlsx'

namespace :data do
  desc 'Load all data from excel files into DB'
  task :store_excel_to_db => ['store_excel_to_db:store_epigenes', 'store_excel_to_db:store_protein_complexes', 'store_excel_to_db:store_histones', 'store_excel_to_db:store_lncrnas']

  task :load_epigenes => [epigenes_filename] do
    epigenes_worksheet = RubyXL::Parser.parse(epigenes_filename).worksheets[0]
    $epigenes = extract_worksheet_data(epigenes_worksheet, EPIGENES_COLUMNS_ORDER)
  end

  task :load_protein_complexes => [protein_complexes_filename] do
    protein_complexes_worksheet = RubyXL::Parser.parse(protein_complexes_filename).worksheets[0]
    $protein_complexes = extract_worksheet_data(protein_complexes_worksheet, PROTEIN_COMPLEXES_COLUMNS_ORDER)
  end

  task :load_histones => [histones_filename] do
    histones_worksheet = RubyXL::Parser.parse(histones_filename).worksheets[0]
    $histones = extract_worksheet_data(histones_worksheet, HISTONES_COLUMNS_ORDER)
  end

  task :load_lncrnas => [lncrnas_filename] do
    lncrnas_worksheet = RubyXL::Parser.parse(lncrnas_filename).worksheets[0]
    $lncrnas = extract_worksheet_data(lncrnas_worksheet, LNCRNAS_COLUMNS_ORDER)
  end

  namespace :store_excel_to_db do
    desc 'Load epigenes from xlsx-file into database'
    task :store_epigenes => [:environment, :load_epigenes] do
      Gene.delete_all
      $epigenes.each do |epigene_info|
        Gene.create!( epigene_info )
      end
    end

    desc 'Load protein complex from xlsx-file into database'
    task :store_protein_complexes => [:environment, :load_protein_complexes, :store_epigenes] do
      ProteinComplex.delete_all
      $protein_complexes.each do |protein_complex_info|
        ProteinComplex.create!( protein_complex_info )
      end

      # cache protein complex's gene inclusion pattern
      ProteinComplex.find_each do |protein_complex|
        protein_complex.genes_in_complex = protein_complex.involved_genes.map{|gene| "#{gene.to_s}##{gene.id}" }.to_s
        protein_complex.save
      end
    end

    desc 'Load histones from xlsx-file into database'
    task :store_histones => [:environment, :load_histones] do
      Histone.delete_all
      $histones.each do |histone_info|
        Histone.create!( histone_info )
      end
    end

    desc 'Load lncrnas from xlsx-file into database'
    task :store_lncrnas => [:environment, :load_lncrnas] do
      Lncrna.delete_all
      $lncrnas.each do |lncrna_info|
        Lncrna.create!( lncrna_info )
      end
    end
  end
end
