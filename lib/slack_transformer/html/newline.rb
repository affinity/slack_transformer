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
        fragment = replace_newline(fragment)

        fragment.to_html(save_with: 0)
      end

      def replace_newline(node)
        node.children.each do |child|
          child.replace("\n") if child.name == 'br'
          replace_newline(child)
        end

        node
      end
    end
  end
end
