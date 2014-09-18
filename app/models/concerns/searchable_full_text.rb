module SearchableFullText
  extend ActiveSupport::Concern
  module ClassMethods
    def searchable_by(searchable_attributes)
      scope :by_word, ->(word) {
        if word.blank?
          all
        else
          search_term_array = Array.new(searchable_attributes.size, "%#{word}%")
          where( searchable_attributes.map{|attr| "\"#{attr}\" ILIKE ?"}.join(' OR '), *search_term_array )
        end
      }
    end
  end
end
