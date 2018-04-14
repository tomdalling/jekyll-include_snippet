module Jekyll
  module IncludeSnippet
    class LiquidTag < Liquid::Tag
      def initialize(tag_name, arg_str, tokens)
        super
        @snippet_name, @source_path = arg_str.split('from').map(&:strip)
      end

      def render(context)
        source_path = @source_path || context['snippet_source']
        if source_path.nil?
          fail "No file path provided for snippet: #{@snippet_name}"
        end

        source = File.read(source_path)
        extractor = Extractor.new
        snippets = extractor.(source)
        snippets.fetch(@snippet_name) do
          fail "Snippet not found: #{@snippet_name}\n    in file: #{@source_path}"
        end
      end
    end
  end
end

Liquid::Template.register_tag('include_snippet', Jekyll::IncludeSnippet::LiquidTag)
