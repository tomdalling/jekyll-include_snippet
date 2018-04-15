# Jekyll::IncludeSnippet

Include snippets of text from external files into your markdown

## Installation

Add it to your `Gemfile`:

    source 'https://rubygems.org'

    gem 'jekyll-include_snippet', github: 'tomdalling/jekyll-include_snippet'

## Usage

Put the special "begin-snippet" and "end-snippet" comments into your source file:

    # blah.rb

    class Blah
      # begin-snippet: my_method_snippet
      def blah
        puts 'blah blah blah'
      end
      # end-snippet
    end

Use it from your markdown:

    Blah blah here is some code:

    ```ruby
    {% include_snippet my_method_snippet from path/to/blah.rb %}
    ```

Alternatively, you can set a default source path in the YAML frontmatter:

    ---
    title: "My Blerg Post"
    date: "2018-01-01"
    snippet_source: "path/to/blah.rb"
    ---

    ```ruby
    {% include_snippet my_method_snippet %}
    ```

And the text from `blah.rb` will be included into your post (and processed as markdown).


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
