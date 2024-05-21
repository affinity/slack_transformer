require 'nokogiri'

module SlackTransformer
  class Html
    class Hyperlinks
      attr_reader :input

      def initialize(input)
        @input = input
      end

      def to_slack
        fragment = Nokogiri::HTML.fragment(input)

        links_to_replace = {}
        fragment.children.each do |child|
          if child.name == 'a'
            hyperlink_text = child.text.empty? ? child.attr('href') : child.text
            hyperlink = "<#{child.attr('href')}|#{hyperlink_text}>"
            links_to_replace[child.to_s] = hyperlink
          end
        end

        links_to_replace.each do |html, hyperlink|
          input.gsub!(html, hyperlink)
        end

      input
      end
    end
  end
end
