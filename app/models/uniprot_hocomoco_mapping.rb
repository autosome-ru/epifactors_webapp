class UniprotHocomocoMapping
  def initialize(triples)
    @human_uniprots_by_hocomoco = Hash.new{|hsh, k| hsh[k] = []}
    @mouse_uniprots_by_hocomoco = Hash.new{|hsh, k| hsh[k] = []}
    @hocomoco_motifs_by_human_uniprot = Hash.new{|hsh, k| hsh[k] = []}
    @hocomoco_motifs_by_mouse_uniprot = Hash.new{|hsh, k| hsh[k] = []}

    triples.each do |hocomoco_motif, human_uniprots, mouse_uniprots|
      human_uniprots ||= ''
      mouse_uniprots ||= ''
      @human_uniprots_by_hocomoco[hocomoco_motif] += human_uniprots.split(',').map(&:strip)
      @mouse_uniprots_by_hocomoco[hocomoco_motif] += mouse_uniprots.split(',').map(&:strip)

      human_uniprots.split(',').map(&:strip).each do |human_uniprot|
        @hocomoco_motifs_by_human_uniprot[human_uniprot] << hocomoco_motif
      end
      mouse_uniprots.split(',').map(&:strip).each do |mouse_uniprot|
        @hocomoco_motifs_by_mouse_uniprot[mouse_uniprot] << hocomoco_motif
      end
    end
  end

  def human_uniprots_by_hocomoco(hocomoco_motif)
    @human_uniprots_by_hocomoco[hocomoco_motif]
  end

  def mouse_uniprots_by_hocomoco(hocomoco_motif)
    @mouse_uniprots_by_hocomoco[hocomoco_motif]
  end

  def hocomoco_motifs_by_human_uniprot(human_uniprot)
    @hocomoco_motifs_by_human_uniprot[human_uniprot]
  end
  def hocomoco_motifs_by_mouse_uniprot(mouse_uniprot)
    @hocomoco_motifs_by_mouse_uniprot[mouse_uniprot]
  end

  def hocomoco_motifs(human_uniprot, mouse_uniprot)
    (hocomoco_motifs_by_human_uniprot(human_uniprot) + hocomoco_motifs_by_mouse_uniprot(mouse_uniprot)).uniq
  end

  def self.read_from_file(filename)
    UniprotHocomocoMapping.new(File.readlines(filename).drop(1).map(&:strip).reject(&:empty?).map{|line| line.split("\t")})
  end

  def self.instance
    @instance ||= UniprotHocomocoMapping.read_from_file( Rails.root.join('db','data','HOCOMOCOv9_motifs2uniprot.txt') )
  end
end
