module Jekyll
  module IncludeSnippet
    class Extractor
      attr_reader :comment_prefix

      def initialize(comment_prefix:)
        @comment_prefix = comment_prefix
      end

      def call(source)
        everything = Snippet.new(name: 'everything', indent: 0)
        all_snippets = []
        active_snippets = []

        source.each_line.each_with_index do |line, lineno|
          case line
          when begin_regex
            active_snippets << Snippet.new(name: $2.strip, indent: $1.length)
          when end_regex
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

      def begin_regex
        %r{
          (\s*)           # optional whitespace (indenting)
          #{Regexp.quote(comment_prefix)} # the comment prefix
          \s*             # optional whitespace
          begin-snippet:  # magic string for beginning a snippet
          (.+)            # the remainder of the line is the snippet name
        }x
      end

      def end_regex
        %r{
          \s*          # optional whitespace (indenting)
          #{Regexp.quote(comment_prefix)} # the comment prefix
          \s*          # optional whitespace
          end-snippet  # Magic string for ending a snippet
        }x
      end

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
