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
            
            if previous.nil?
              child.replace("#{child.children.to_html}")
            else
              child.replace("\n#{child.children.to_html}")
            end

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
