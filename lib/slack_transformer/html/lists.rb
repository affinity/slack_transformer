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

        fragment.to_html(save_with: 0)
      end

      def indent_nested_list(child, num_indent = 0)
        child.children.map do |c|

          case c.name
          when 'li'
            indent_nested_list(c, num_indent)
          when 'ul'
            indent_nested_list(c, num_indent += 1)
          else
            "#{"\t" * num_indent}• #{c.to_html(save_with: 0)}"
          end
        end.join("\n")
      end

      def indent_nested_number_list(child, num_indent = 0, index = 0)
        child.children.map do |c|
          case c.name
          when 'li'
            indent_nested_number_list(c, num_indent, index += 1)
          when 'ol'
            indent_nested_number_list(c, num_indent += 1, 0)
          else
            "#{"\t" * num_indent}#{index}. #{c.to_html(save_with: 0)}"
          end
        end.join("\n")
      end
    end
  end
end
