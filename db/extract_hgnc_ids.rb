require 'rubyXL'

workbook = RubyXL::Parser.parse('EpiGenes&Complexes_main_1.4beta_ver10.06.2014.xlsx')
epigenes_worksheet = workbook.worksheets[0]
complexes_worksheet = workbook.worksheets[1]

hgnc_ids = []

epigenes_worksheet.extract_data.drop(1).each do |row|

  hgnc_symbol, hgnc_id, hgnc_name, gene_id,
  refseq_hs, uniprot_ac, uniprot_id, mgi_id,
  refseq_mm, ec_number, ec_description, gene_tag,
  gene_desc, funct_class, funct, funct_pmid,
  protein_complex, protein_complex_pmid, target,
  target_molecule, product, product_pmid, details = *row

  hgnc_ids << hgnc_id
end

puts hgnc_ids.uniq
