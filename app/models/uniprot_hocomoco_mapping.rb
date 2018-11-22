class UniprotHocomocoMapping
  def initialize(motif_names)
    @motifs_by_uniprot = motif_names.group_by{|motif| uniprot_by_motif(motif) }
  end

  def motifs_by_uniprots(*uniprots)
    @motifs_by_uniprot.values_at(*uniprots).compact.flatten.uniq
  end

  def uniprot_by_motif(motif)
    motif.split('.').first
  end

  def self.read_from_file(filename)
    self.new(File.readlines(filename).map(&:strip))
  end

  def self.instance
    @instance ||= self.read_from_file( Rails.root.join('public', 'public_data', 'HOCOMOCOv11_motifs.txt') )
  end
end
