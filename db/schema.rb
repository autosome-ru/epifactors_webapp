# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140627074014) do

  create_table "gene_complexes", force: true do |t|
    t.integer  "complex_group"
    t.string   "complex_group_name"
    t.string   "complex_name"
    t.string   "alternative_names"
    t.text     "proteins_involved"
    t.text     "uniprot_ids"
    t.string   "funct"
    t.string   "complex_members_pmid"
    t.string   "target"
    t.string   "target_molecule"
    t.string   "product"
    t.string   "function_pmid"
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genes", force: true do |t|
    t.string   "hgnc_symbol"
    t.integer  "hgnc_id"
    t.string   "hgnc_name"
    t.integer  "gene_id"
    t.string   "refseq_hs"
    t.string   "uniprot_ac"
    t.string   "uniprot_id"
    t.string   "mgi_id"
    t.string   "refseq_mm"
    t.string   "ec_number"
    t.string   "ec_description"
    t.string   "gene_tag"
    t.string   "gene_desc"
    t.string   "funct_class"
    t.string   "funct"
    t.string   "funct_pmid"
    t.string   "protein_complex"
    t.string   "protein_complex_pmid"
    t.string   "target"
    t.string   "target_molecule"
    t.string   "product"
    t.string   "product_pmid"
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
