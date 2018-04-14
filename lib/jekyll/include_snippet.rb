require 'liquid'

module Jekyll
  module IncludeSnippet
  end
end

%w(version extractor liquid_tag).each do |file|
  require "jekyll/include_snippet/#{file}"
end

