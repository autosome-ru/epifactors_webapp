class Histone < ActiveRecord::Base
  searchable_attributes = [:hgnc_symbol, :hgnc_name, :refseq_hs, :uniprot_ac, :uniprot_id, :mgi_id, :refseq_mm, :ec_descr, :gene_tag, :gene_desc]
  scope :by_word, ->(word) {
    if word.blank?
      all
    else
      where(searchable_attributes.map{|attr| "#{attr} LIKE ?"}.join(' OR '),
            *(["%#{word}%"]*searchable_attributes.size) )
    end
  }
end
