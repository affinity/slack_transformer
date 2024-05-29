require 'nokogiri'

module SlackTransformer
  class Html
    class Paragraph
      attr_reader :input

      def initialize(input)
        @input = input
      end

      def to_slack
        fragment = Nokogiri::HTML.fragment(input)
        previous = nil
        fragment.children.each do |child|
          if child.name == 'p'
            newline = previous.nil? ? "" : "\n"
            child.replace("#{newline}#{child.children.to_html}")
            # We don't want to add a newline after the last paragraph tag if it's empty.  
            previous = child.children.empty? ? nil : 'p'
          else
            current = child.name 
            child.replace("\n#{child.to_html}") if previous == 'p'
            previous = current
          end
        end

        fragment.to_html
      end
    end
  end
end
