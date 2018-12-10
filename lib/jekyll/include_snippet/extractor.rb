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

        source.each_line.each_with_index do |line, lineno|
          case line
          when BEGIN_REGEX
            active_snippets << Snippet.new(name: $2.strip, indent: $1.length)
          when END_REGEX
            raise missing_begin_snippet(lineno) if active_snippets.empty?
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

      def missing_begin_snippet(lineno)
        <<~END_ERROR
          There was an `end-snippet` on line #{lineno}, but there doesn't
          appear to be any matching `begin-snippet` line.

          Make sure you have the correct `begin-snippet` comment --
          something like this:

              # begin-snippet: MyRadCode

        END_ERROR
      end

      class Snippet
        attr_reader :name, :indent, :lines

        def initialize(name:, indent:)
          @name = name
          @indent = indent
          @lines = []
        end

        def dedented_text
          lines
            .map { |line| dedent(line) }
            .join
            .rstrip
        end

        def dedent(line)
          if line.length >= indent
            line[indent..-1]
          else
            line
          end
        end
      end
    end
  end
end
