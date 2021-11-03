require_relative 'base'

module Functions
  module Substitutions
    class XpathTableElementInRow < Functions::Substitutions::Base
      XPATH_SEARCH_STRING = "<table_xpath>//*[contains(text(), '<key_word>')]/ancestor::tr//*[contains(text(), '<text_for_search>')]".freeze

      attr_accessor :table_xpath, :key_word, :text_for_search
      validates :table_xpath, :key_word, :text_for_search, presence: true

      def calculate
        XPATH_SEARCH_STRING.sub('<table_xpath>', table_xpath).sub('<key_word>', key_word).sub('<text_for_search>', text_for_search)
      end

      def map_arguments
        [:table_xpath, :key_word, :text_for_search]
      end
    end
  end
end