require 'ostruct'

RSpec.describe Jekyll::IncludeSnippet::LiquidTag do
  subject do
    tag = described_class.parse('include_snippet', args, nil, options)
    tag.render(context)
  end
  let(:options) { OpenStruct.new(line_number: 123) }

  before(:each) do
    allow(File).to receive(:read).with('path/to/buzz.rb').and_return(<<~END_SOURCE)
      #begin-snippet: geralt_from_rivia
      I hate portals
      #end-snippet
    END_SOURCE
  end

  context 'with explicit source path argument to tag' do
    let(:context) { {} }
    let(:args) { "geralt_from_rivia from path/to/buzz.rb" }

    it { is_expected.to eq('I hate portals') }
  end

  context 'with implicit source path taken from context' do
    # this context mimics the open that Jekyll provides
    let(:context) {{ 'page' => { 'snippet_source' => 'path/to/buzz.rb' } }}
    let(:args) { "geralt_from_rivia" }

    it { is_expected.to eq('I hate portals') }
  end

  context 'without any source path defined' do
    let(:context) { {} }
    let(:args) { "doesnt_matter" }

    it 'causes an error' do
      expect { subject }.to raise_error(RuntimeError)
    end
  end
end
