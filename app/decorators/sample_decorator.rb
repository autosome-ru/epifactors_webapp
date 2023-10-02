class SampleDecorator < ApplicationDecorator
  delegate_all
  def fantom_sstar_link
    h.link_to 'FANTOM5 SSTAR', "https://fantom.gsc.riken.jp/5/sstar/FF:#{ object.extract_name }"
  end
end
