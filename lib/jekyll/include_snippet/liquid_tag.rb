module Jekyll
  module IncludeSnippet
    class LiquidTag < Liquid::Tag
      DEFAULT_COMMENT_PREFIX = '#'

      def initialize(tag_name, arg_str, tokens)
        super
        @snippet_name, @source_path = arg_str.split(/\sfrom\s/).map(&:strip)
      end

      def render(context)
        source_path = source_path_for(context)
        source = File.read(source_path)
        extractor = Extractor.new(comment_prefix: comment_prefix_for(context))
        snippets = extractor.(source)
        snippets.fetch(@snippet_name) do
          fail "Snippet not found: #{@snippet_name.inspect}\n    in file: #{@source_path}"
        end
      end

      private

      def source_path_for(context)
        result = get_option(:snippet_source, context) || @source_path

        if result.nil?
          fail "No source path provided for snippet: #{@snippet_name}"
        end

        result
      end

      def comment_prefix_for(context)
        get_option(:snippet_comment_prefix, context) || DEFAULT_COMMENT_PREFIX
      end

      def get_option(option_name, context)
        page = context['page']
        page && page[option_name.to_s]
      end
    end
  end
end

Liquid::Template.register_tag('include_snippet', Jekyll::IncludeSnippet::LiquidTag)
