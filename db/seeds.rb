# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'rubyXL'

workbook = RubyXL::Parser.parse(Rails.root.join('db','EpiGenes&Complexes_main_1.4beta_Grigory_ver27062014.xlsx'))
epigenes_worksheet = workbook.worksheets[0]
complexes_worksheet = workbook.worksheets[1]
histones_worksheet = RubyXL::Parser.parse(Rails.root.join('db','EpiGenes_histones_1.1beta.xlsx')).worksheets[0]

epigenes_worksheet.extract_data.drop(1).each_with_index do |row, ind|

  hgnc_symbol, hgnc_id, hgnc_name, gene_id,
  refseq_hs, uniprot_ac, uniprot_id, mgi_id,
  refseq_mm, ec_number, ec_description, gene_tag,
  gene_desc, funct_class, funct, funct_pmid,
  protein_complex, protein_complex_pmid, target,
  target_molecule, product, product_pmid, details = *row

  Gene.where(id: ind + 1).first_or_create(
      hgnc_symbol:hgnc_symbol, hgnc_id:hgnc_id, hgnc_name:hgnc_name, gene_id:gene_id,
      refseq_hs:refseq_hs, uniprot_ac:uniprot_ac, uniprot_id:uniprot_id, mgi_id:mgi_id,
      refseq_mm:refseq_mm, ec_number:ec_number, ec_description:ec_description, gene_tag:gene_tag,
      gene_desc:gene_desc, funct_class:funct_class, funct:funct, funct_pmid:funct_pmid,
      protein_complex:protein_complex, protein_complex_pmid:protein_complex_pmid, target:target,
      target_molecule:target_molecule, product:product, product_pmid:product_pmid, details:details)
end


complexes_worksheet.extract_data.drop(1).each_with_index do |row, ind|

  complex_group, complex_group_name, complex_name,
  alternative_names, proteins_involved, uniprot_ids,
  complex_members_pmid, funct, function_pmid, target_molecule,
  target, product, targets_and_products_pmid,  details = *row

  GeneComplex.where(id: ind + 1).first_or_create(
      complex_group:complex_group, complex_group_name:complex_group_name, complex_name:complex_name,
      alternative_names:alternative_names, proteins_involved:proteins_involved, uniprot_ids:uniprot_ids,
      funct:funct, complex_members_pmid:complex_members_pmid, target:target, target_molecule:target_molecule,
      product:product, function_pmid:function_pmid, details:details, targets_and_products_pmid: targets_and_products_pmid)
end

# File.readlines(Rails.root.join('db','tissue_names.txt')).each_with_index do |line, ind|
#   Tissue.where(id: ind).first_or_create(name: line.strip)
# end

# File.readlines(Rails.root.join('db','gene_expressions_by_tissue.txt')).each do |line|
#   hgnc_id, *expressions = line.strip.split("\t")
#   expressions.each_with_index do |expr, ind|
#     GeneExpression.where(hgnc_id: hgnc_id, tissue_id: ind).first_or_create(expression: expr)
#   end
# end

histones_worksheet.extract_data.drop(1).each_with_index do |row, ind|
  hgnc_symbol, hgnc_id, hgnc_name, gene_id, refseq_hs, uniprot_ac,
  uniprot_id, mgi_id, refseq_mm, ec_number, ec_descr, gene_tag, gene_desc = *row

  Histone.where(id: ind + 1).first_or_create(
      hgnc_symbol: hgnc_symbol, hgnc_id: hgnc_id, hgnc_name: hgnc_name,
      gene_id: gene_id, refseq_hs: refseq_hs, uniprot_ac: uniprot_ac,
      uniprot_id: uniprot_id, mgi_id: mgi_id, refseq_mm: refseq_mm,
      ec_number: ec_number, ec_descr: ec_descr, gene_tag: gene_tag,
      gene_desc: gene_desc
  )
end
