module Jekyll
  module IncludeSnippet
    class Extractor
      BEGIN_REGEX = %r{
        (\s*)\#\s*      # Line must start with a hash (surrounding whitespace optional)
        begin-snippet:  # Magic string for beginning a snippet
        (.+)            # The remainder of the line is the snippet name
      }x

      END_REGEX = %r{
        \s*\#\s*     # Line must start with a hash (surrounding whitespace optional)
        end-snippet  # Magic string for ending a snippet
      }x

      def call(source)
        everything = Snippet.new(name: 'everything', indent: 0)
        all_snippets = []
        active_snippets = []

        source.each_line do |line|
          case line
          when BEGIN_REGEX
            active_snippets << Snippet.new(name: $2.strip, indent: $1.length)
          when END_REGEX
            all_snippets << active_snippets.pop
          else
            (active_snippets + [everything]).each do |snippet|
              snippet.lines << line
            end
          end
        end

        (all_snippets + [everything])
          .map { |s| [s.name, s.dedented_text] }
          .to_h
      end

      private

      class Snippet
        attr_reader :name, :indent, :lines

        def initialize(name:, indent:)
          @name = name
          @indent = indent
          @lines = []
        end

        def dedented_text
          lines
            .map { |l| l[indent..-1] }
            .join
            .rstrip
        end
      end
    end
  end
end
