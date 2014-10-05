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

ActiveRecord::Schema.define(version: 20141005145843) do

  create_table "gene_in_complexes", force: true do |t|
    t.integer  "protein_complex_id"
    t.integer  "gene_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gene_in_complexes", ["gene_id"], name: "index_gene_in_complexes_on_gene_id"
  add_index "gene_in_complexes", ["protein_complex_id"], name: "index_gene_in_complexes_on_protein_complex_id"

  create_table "genes", force: true do |t|
    t.string   "hgnc_symbol"
    t.string   "status"
    t.string   "hgnc_id"
    t.string   "hgnc_name"
    t.string   "gene_id"
    t.string   "uniprot_ac"
    t.string   "uniprot_id"
    t.text     "domain"
    t.string   "mgi_symbol"
    t.string   "mgi_id"
    t.string   "uniprot_ac_mm"
    t.string   "uniprot_id_mm"
    t.string   "gene_tag"
    t.string   "gene_desc"
    t.string   "functional_class"
    t.string   "function"
    t.string   "pmid_function"
    t.string   "complex_name"
    t.string   "target"
    t.string   "specific_target"
    t.string   "product"
    t.string   "uniprot_id_target"
    t.string   "pmid_target"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "histones", force: true do |t|
    t.string   "hgnc_symbol"
    t.string   "status"
    t.string   "hgnc_id"
    t.string   "hgnc_name"
    t.string   "gene_id"
    t.string   "uniprot_ac"
    t.string   "uniprot_id"
    t.string   "domain"
    t.string   "mgi_symbol"
    t.string   "mgi_id"
    t.string   "uniprot_ac_mm"
    t.string   "uniprot_id_mm"
    t.string   "gene_tag"
    t.string   "gene_desc"
    t.string   "complex_name"
    t.string   "targeted_by_protein"
    t.string   "targeted_by_complex"
    t.string   "pmid"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "protein_complexes", force: true do |t|
    t.string   "group"
    t.string   "group_name"
    t.string   "complex_name"
    t.string   "status"
    t.string   "alternative_name"
    t.text     "protein"
    t.text     "uniprot_id"
    t.string   "pmid_complex"
    t.string   "function"
    t.string   "pmid_function"
    t.string   "target"
    t.string   "specific_target"
    t.string   "product"
    t.text     "uniprot_id_target"
    t.string   "pmid_target"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
