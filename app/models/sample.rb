class Sample
  SAMPLE_NAME_PATTERN = /^(?<sample_name>.+)\.(?<library_name>CNhs\w+)\.(?<extract_name>\w+-\w+)$/
  SDRF_FILENAME_PATTERN = /^00_(?<organism>human|mouse)\.(?<sample_kind>\w+)\.(?<quality>\w+)\.(?<genome_assembly>\w+).assay_sdrf.txt$/
  attr_reader :organism, :sample_kind, :library_name, :extract_name, :sample_name
  alias sample_id library_name

  # organism_name: Homo sapiens
  # sample_kind: cell_line
  # library_name: CNhs10722
  # extract_name: 10399-106A3
  # sample_name: acute myeloid leukemia (FAB M5) cell line:THP-1 (fresh)
  def initialize(organism, sample_kind, library_name, extract_name, sample_name)
    @organism = organism.to_sym
    @sample_kind = sample_kind.to_sym
    @library_name = library_name.to_sym
    @extract_name = extract_name.to_sym
    @sample_name = sample_name
  end

  def full_name
    "#{sample_name}.#{library_name}.#{extract_name}"
  end

  def to_s
    full_name
  end

  def hash
    [organism, sample_kind, library_name, extract_name, sample_name].hash
  end

  def eql?(other)
    other.class.eql?(self.class) &&
    organism == other.organism &&
    sample_kind == other.sample_kind &&
    library_name == other.library_name &&
    extract_name == other.extract_name &&
    sample_name == other.sample_name
  end

  def ==(other)
    other.is_a?(Sample) &&
    organism == other.organism &&
    sample_kind == other.sample_kind &&
    library_name == other.library_name &&
    extract_name == other.extract_name &&
    sample_name == other.sample_name
  end

  def self.find_by_full_name(full_name)
    match = full_name.match(SAMPLE_NAME_PATTERN)
    match && self.find_by_sample_id(match[:library_name].to_sym)
  end

  def self.cache_reset!
    @cache_all = nil
    @cache_index = nil
  end

  def self.find_by_sample_id(sample_id)
    @cache_index ||= self.all.map{|sample| [sample.sample_id, sample] }.to_h
    @cache_index[sample_id.to_sym]
  end

  def self.all
    @cache_all ||= self.load_samples_from_folder( Rails.root.join('public', 'public_data', 'fantom_sample_infos') )
  end

  # # See https://github.com/charles-plessy/tutorial/blob/master/FANTOM5_SDRF_files/sdrf.md for help with FANTOM samples data
  # # Download:
  # PHASE='latest'
  # echo 'mget */*sdrf.txt' |   lftp http://fantom.gsc.riken.jp/5/datafiles/$PHASE/basic
  def self.load_samples_from_folder(folder)
    Dir.glob(File.join(folder, '*')).select{|filename|
      File.basename(filename).match(SDRF_FILENAME_PATTERN) # Don't include unclassified files
    }.flat_map{|filename|
      match = File.basename(filename).match(SDRF_FILENAME_PATTERN)
      samples = File.readlines(filename).drop(1).map{|line|
        extract_name_1, comment_rna_tube, sample_name, organism,
        protocol_ref_1, rna_extraction, extract_name_2, rna_id, material_type, comment_on_rna,
        protocol_ref_2, lsid, library_protocol, library_name, library_id,
        protocol_ref_3, sequence_protocol, machine_name, run_name, flowcell_channel, file_name_1, sequence_raw_file,
        protocol_ref_4, sex, file_name_2  = line.chomp.split("\t")

        extract_name_2 = extract_name_2.sub(/\.rna$/,'')
        raise "They were treated equal, but they aren't. Find which one to choose:\n" +
              "extract_name_1=#{extract_name_1}; extract_name_2=#{extract_name_2}"  unless extract_name_1 == extract_name_2
        raise "They were treated equal, but they aren't. Find which one to choose:\n" +
              "library_name=#{library_name}; library_id=#{library_id}"  unless library_name == library_id

        Sample.new(organism, match[:sample_kind], library_name, extract_name_1, sample_name)
      }
    }
  end
end
