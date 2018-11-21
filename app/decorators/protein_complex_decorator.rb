class ProteinComplexDecorator < ApplicationDecorator
  delegate_all
  def complex_name_link(text = nil)
     h.link_to(text || object.complex_name, h.protein_complex_path(object))
  end

  def complex_name_with_complex_card_link
    ( object.complex_name + '<br/>' + complex_name_link('(details)') ).html_safe
  end
end
