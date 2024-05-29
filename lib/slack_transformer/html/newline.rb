require 'nokogiri'

module SlackTransformer
  class Html
    class Newline
      attr_reader :input

      def initialize(input)
        @input = input
      end

      def to_slack
        fragment = Nokogiri::HTML.fragment(input)

        fragment.children.each do |child|
          child.replace("\n") if child.name == 'br'
        end

        fragment.to_html
      end
    end
  end
end
