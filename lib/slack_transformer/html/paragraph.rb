require 'nokogiri'

module SlackTransformer
  class Html
    class Paragraph
      attr_reader :input

      NEWLINE = "\n"
      EMPTY = ""
      P_TAG = 'p'
      LI_TAG = 'li'

      def initialize(input)
        @input = input
      end

      def to_slack
        fragment = Nokogiri::HTML.fragment(input)
        fragment = handle_p_tag(fragment)
        fragment.to_html(save_with: 0)
      end

      def handle_p_tag(parent)
        previous = nil

        parent.children.each do |child|
          if child.name == P_TAG
            # Only add new line in between p tags.
            newline = previous == P_TAG ? NEWLINE : EMPTY
            children_html = handle_p_tag(child).children.to_html(save_with: 0)
            child.replace("#{newline}#{children_html}")
            previous = P_TAG
          else
            current = child.name
            # Only add new line if previous element is a p tag AND we are not within a list.
            newline = previous == P_TAG && parent.name != LI_TAG ? NEWLINE : EMPTY
            child_html = handle_p_tag(child).to_html(save_with: 0)
            child.replace("#{newline}#{child_html}")
            previous = current
          end
        end

        parent
      end
    end
  end
end
