require 'nokogiri'

module SlackTransformer
  class Html
    class Paragraph
      attr_reader :input

      NEWLINE = "\n"
      EMPTY = ""
      P_TAG = 'p'
      LI_TAG = 'li'
      EMPTY_P_TAG = '<p/>'

      def initialize(input)
        @input = input
      end

      def to_slack
        fragment = Nokogiri::HTML.fragment(input)
        fragment = handle_p_tag(fragment)
        # The save with option ensures that we do not add additional newlines to the html.
        fragment.to_html(save_with: 0)
      end

      def handle_p_tag(parent)
        previous = nil

        parent.children.each do |child|
          if child.name == P_TAG
            children_html = handle_p_tag(child).children.to_html(save_with: 0)
            is_empty = children_html.empty?
            # Add newline if there is a previous element or is an empty P tag.
            newline = !previous.nil? || is_empty ? NEWLINE : EMPTY
            child.replace("#{newline}#{children_html}")
            previous = is_empty ? EMPTY_P_TAG : P_TAG
          else
            # Do nothing if dealing with an empty child.
            next if child.content.strip.empty?

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
