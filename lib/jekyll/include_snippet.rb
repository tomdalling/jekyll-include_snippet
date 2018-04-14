module Jekyll
  module IncludeSnippet
  end
end

%w(version extractor).each do |file|
  require "jekyll/include_snippet/#{file}"
end

