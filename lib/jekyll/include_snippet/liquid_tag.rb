module Jekyll
  module IncludeSnippet
    class LiquidTag < Liquid::Tag
      def initialize(tag_name, arg_str, tokens)
        super
        @snippet_name, @source_path = arg_str.split('from').map(&:strip)
      end

      def render(context)
        source_path = source_path_for(context)
        source = File.read(source_path)
        extractor = Extractor.new
        snippets = extractor.(source)
        snippets.fetch(@snippet_name) do
          fail "Snippet not found: #{@snippet_name.inspect}\n    in file: #{@source_path}"
        end
      end

      private

      def source_path_for(context)
        page = context['page']
        frontmatter_default_source = page && page['snippet_source']
        result = frontmatter_default_source || @source_path

        if result.nil?
          fail "No source path provided for snippet: #{@snippet_name}"
        end

        result
      end
    end
  end
end

Liquid::Template.register_tag('include_snippet', Jekyll::IncludeSnippet::LiquidTag)
