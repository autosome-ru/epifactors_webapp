module ApplicationHelper
  def table_info_row(obj, attrib, html_options = {}, &block)
    key_column = content_tag :td, html_options[:key_column_html] do
      I18n.t "activerecord.attributes.#{ActiveSupport::Inflector.underscore(obj.class.model_name)}.#{attrib}"
    end
    value_column = content_tag :td, html_options[:value_column_html] do
      if block_given?
        block.call(obj).to_s
      else
        obj.send(attrib).to_s
      end
    end
    content_tag :tr, html_options[:row_html] do
      (key_column + value_column).html_safe
    end

  end
end
