class HistoneDecorator < Draper::Decorator
  delegate_all

  def hgnc_symbol
    ( object.hgnc_symbol + '<br/>' + h.link_to('(histone info)', h.histone_path(object)) ).html_safe
  end

  def refseq_mm
    (object.refseq_mm || '').split('|').join(', ')
  end

  def refseq_hs
    (object.refseq_hs || '').split('|').join(', ')
  end
end
