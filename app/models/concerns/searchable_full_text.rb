module SearchableFullText
  extend ActiveSupport::Concern
  module ClassMethods
    def fulltext_searchable_by(searchable_attributes)
      scope :by_word, ->(word) {
        if word.blank?
          all
        else
          search_term_array = Array.new(searchable_attributes.size, "%#{word}%")
          where( searchable_attributes.map{|attr| "\"#{attr}\" LIKE ?"}.join(' OR '), *search_term_array )
        end
      }
    end

    def define_search_by_attributes
      scope :by_attr_similar, ->(attr_name, value) {
        attr_name = attr_name.to_s
        raise 'Wrong attribute'  unless attribute_names.include?(attr_name)
        where("\"#{attr_name}\" LIKE ?", "%#{value}%")
      }

      scope :by_attr_exact, ->(attr_name, value) {
        attr_name = attr_name.to_s
        raise 'Wrong attribute'  unless attribute_names.include?(attr_name)
        where( { attr_name => value } )
      }
    end

    def by_params(params)
      if params[:search]
        query = params[:search].strip
        if params[:field]
          if params[:similar]
            by_attr_similar(params[:field], query)
          else
            by_attr_exact(params[:field], query)
          end
        else # full-text search
          by_word(query) # TODO: It would be good if `by_word` concerned about params[:similar] too. For now it's turned on by default
        end
      else
        all
      end
    end
  end
end
