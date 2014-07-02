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

  def table_header(content, options = {})
    klasses = []
    klasses << 'sorter-false'  if options[:dont_sort]
    klasses << 'columnSelector-disable'  if options[:show_always]
    klasses << 'columnSelector-false'  if options[:hide_by_default]
    if options[:class]
      klasses += options[:class]  if options[:class].is_a? Array
      klasses += options[:class].split(/[\s,]/)  if options[:class].is_a? String
    end
    content_tag :th, options.merge(class: klasses.uniq) do
      content
    end
  end
end
