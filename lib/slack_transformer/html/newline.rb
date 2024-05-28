require 'nokogiri'

module SlackTransformer
  class Html
    class Newline
      attr_reader :input

      def initialize(input)
        @input = input
      end

      def to_slack
        # input.gsub(/<\/?p>/, '\n')
        fragment = Nokogiri::HTML.fragment(input)

        fragment.children.each do |child|
          case child.name
          when 'p'
            child.replace("\n #{child.children.to_html} \n")
          when 'br'
            child.replace("\n")
          end
        end

        fragment.to_html
      end
    end
  end
end
