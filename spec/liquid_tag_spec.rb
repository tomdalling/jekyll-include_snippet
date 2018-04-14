require 'ostruct'

RSpec.describe Jekyll::IncludeSnippet::LiquidTag do
  subject { described_class.parse('include_snippet', args, nil, options) }
  let(:args) { "fizz from path/to/buzz.rb" }
  let(:options) { OpenStruct.new({
    line_number: 123,
  })}

  it 'renders snippets from files' do
    allow(File).to receive(:read).with('path/to/buzz.rb').and_return(<<~END_SOURCE)
      #begin-snippet: fizz
      This is the fizz snippet
      #end-snippet
    END_SOURCE

    expect(subject.render(nil)).to eq('This is the fizz snippet')
  end
end
