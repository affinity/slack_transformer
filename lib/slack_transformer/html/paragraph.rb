require 'nokogiri'

module SlackTransformer
  class Html
    class Paragraph
      attr_reader :input

      P_TAG = 'p'

      def initialize(input)
        @input = input
      end

      def to_slack
        fragment = Nokogiri::HTML.fragment(input)
        fragment = handle_p_tag(fragment)
        fragment.to_html
      end

      def handle_p_tag(node)
        previous = nil

        node.children.each do |child|
          if child.name == P_TAG
            # Only add new line in between p tags.
            newline = previous == P_TAG ? "\n" : ""
            child.replace("#{newline}#{handle_p_tag(child).children.to_html}")
            previous = P_TAG
          else
            current = child.name
            newline = previous == P_TAG ? "\n" : ""
            child.replace("#{newline}#{handle_p_tag(child).to_html}")
            previous = current
          end
        end

        node
      end
    end
  end
end
