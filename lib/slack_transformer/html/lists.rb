require 'nokogiri'

module SlackTransformer
  class Html
    class Lists
      attr_reader :input

      def initialize(input)
        @input = input
      end

      def to_slack
        fragment = Nokogiri::HTML.fragment(input)

        fragment.children.each do |child|
          case child.name
          when 'ul'
            child.replace(indent_nested_list(child))
          when 'ol'
            child.replace(indent_nested_number_list(child))
          end
        end

        # The save with option ensures that we do not add additional newlines to the html.
        fragment.to_html(save_with: 0)
      end

      def indent_nested_list(child, num_indent = 0)
        previous = nil
        child.children.map do |c|
          case c.name
          when 'li'
            prev = c.previous_sibling&.name
            newline = prev == 'li' ? "\n" : ""
            "#{newline}#{"\t" * num_indent}• #{indent_nested_list(c, num_indent)}"
          when 'ul'
            "\n#{indent_nested_list(c, num_indent + 1)}"
          else
            if c.parent&.name == 'li'
              # If elements within the list has any newlines, add tabs accordingly.
              c.content=(c.content.split("\n").join("\n#{"\t" * num_indent}"))
            end
            c.to_html(save_with: 0)
          end
        end.join
      end

      def indent_nested_number_list(child, num_indent = 0, index = 1)
        previous = nil
        child.children.map do |c|
          case c.name
          when 'li'
            prev = c.previous_sibling&.name
            newline = prev == 'li' ? "\n" : ""
            "#{newline}#{"\t" * num_indent}#{index}. #{indent_nested_number_list(c, num_indent, index += 1)}"
          when 'ol'
            "\n#{indent_nested_number_list(c, num_indent + 1, 1)}"
          else
            if c.parent&.name == 'li'
              # If elements within the list has any newlines, add tabs accordingly.
              c.content=(c.content.split("\n").join("\n#{"\t" * num_indent}"))
            end
            c.to_html(save_with: 0)
          end
        end.join
      end
    end
  end
end
