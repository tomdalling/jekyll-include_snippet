# Jekyll::IncludeSnippet

Include snippets of text from external files into your markdown

## Installation

Add it to your `Gemfile` (in a way that Jekyll will load):

    source 'https://rubygems.org'

    group :jekyll_plugins do
      gem 'jekyll-include_snippet'
    end

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

    ---
    title: "My Blerg Post"
    date: "2018-01-01"
    ---

    Blah blah here is some code:

    ```ruby
    {% include_snippet my_method_snippet from path/to/blah.rb %}
    ```

Optionally, you can set a default source path in the YAML frontmatter:

    ---
    title: "My Blerg Post"
    date: "2018-01-01"
    snippet_source: "path/to/blah.rb"
    ---

    ```ruby
    {% include_snippet my_method_snippet %}
    ```

## Languages Other Than Ruby

If you're using another language, you will probably need to change the "comment prefix".

    ---
    title: "My Blerg Post"
    date: "2018-01-01"
    snippet_comment_prefix: "//"
    ---

    ```js
    {% include_snippet whatever from whatever.js %}
    ```

```js
// whatever.js

// begin-snippet: whatever
function whatever() {
  console.log("Hello there");
}
// end-snippet
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## TODO

 - Could easily be optimised for better performance
 - Maybe a feature for evaluating code and including the result
