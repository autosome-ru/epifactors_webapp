class SampleDecorator < Draper::Decorator
  delegate_all
  def fantom_sstar_link
    h.link_to 'FANTOM5 SSTAR', "http://fantom.gsc.riken.jp/5/sstar/FF:#{ object.extract_name }"
  end
end
