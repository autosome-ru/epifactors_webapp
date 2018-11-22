class GeneDecorator < ApplicationDecorator
  delegate_all

  def hocomoco_link
    object.hocomoco_motifs.map{|motif|
      species = motif.split('.').first.split('_')[1]
      img_url = ENV['HOCOMOCO11_URL'] + "final_bundle/hocomoco11/full/#{species}/mono/logo_small/#{motif}_direct.png"
      motif_url = ENV['HOCOMOCO11_URL'] + "motif/#{motif}"
      h.content_tag(:div, class: 'hocomoco_link'){
        h.link_to(motif_url){
          (motif + h.tag(:img, src: img_url)).html_safe
        }
      }
    }.join.html_safe
  end
end
