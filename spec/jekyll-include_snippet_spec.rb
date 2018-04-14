require "spec_helper"

RSpec.describe Jekyll::IncludeSnippet do
  it "has a version number" do
    expect(Jekyll::IncludeSnippet::VERSION.split('.').size).to eq(3)
  end
end
