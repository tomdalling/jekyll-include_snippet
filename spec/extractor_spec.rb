RSpec.describe Jekyll::IncludeSnippet::Extractor do
  subject { extractor.(input) }
  let(:extractor) { described_class.new }

  context 'a simple snippet' do
    let(:input) { <<~END_INPUT }
      This is the first line

      # begin-snippet: wakka
      This is the wakka snippet.
      # end-snippet

      Last line.
    END_INPUT

    its(['wakka']) { is_expected.to eq('This is the wakka snippet.') }
    its(['everything']) { is_expected.to eq(<<~END_TEXT.strip) }
      This is the first line

      This is the wakka snippet.

      Last line.
    END_TEXT
  end

  context 'nested snippets' do
    let(:input) { <<~END_INPUT }
      #begin-snippet: outer
      This is outer
      #begin-snippet: inner
      This is inner
      #end-snippet
      #end-snippet
    END_INPUT

    its(['inner']) { is_expected.to eq('This is inner') }
    its(['outer']) { is_expected.to eq("This is outer\nThis is inner") }
  end

  context 'indented snippets' do
    let(:input) { <<~END_INPUT }
      First
        #begin-snippet: indented
              I
                  am
           indented
                 #end-snippet
      Last
    END_INPUT

    its(['indented']) { is_expected.to eq(
      [
        "      I",
        "          am",
        "   indented"
      ].join("\n")
    ) }

    its(['everything']) { is_expected.to eq(
      [
        "First",
        "        I",
        "            am",
        "     indented",
        "Last"
      ].join("\n")
    ) }
  end
end
