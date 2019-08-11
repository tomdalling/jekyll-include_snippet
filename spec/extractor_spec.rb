RSpec.describe Jekyll::IncludeSnippet::Extractor do
  subject { extractor.(input) }
  let(:extractor) { described_class.new(comment_prefix: '#') }

  context 'a simple snippet' do
    let(:input) { <<~END_INPUT }
      This is the first line

      # begin-snippet: wakka
      This is the wakka snippet.
      # end-snippet

      Last line.
    END_INPUT

    it "works" do
      expect(subject['wakka']).to eq('This is the wakka snippet.')
      expect(subject['everything']).to eq(<<~END_TEXT.strip)
        This is the first line

        This is the wakka snippet.

        Last line.
      END_TEXT
    end
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

    it 'works' do
      expect(subject['inner']).to eq('This is inner')
      expect(subject['outer']).to eq("This is outer\nThis is inner")
    end
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

    it 'works' do
      expect(subject['indented']).to eq([
        "      I",
        "          am",
        "",
        "   indented"
      ].join("\n"))

      expect(subject['everything']).to eq([
        "First",
        "        I",
        "            am",
        "",
        "     indented",
        "Last"
      ].join("\n"))
    end
  end

  context 'ending a snippet that never began' do
    let(:input) { "# end-snippet\n" }

    it "raises a nice error" do
      expect { subject }.to raise_error(<<~END_ERROR)
        There was an `end-snippet` on line 0, but there doesn't
        appear to be any matching `begin-snippet` line.

        Make sure you have the correct `begin-snippet` comment --
        something like this:

            # begin-snippet: MyRadCode

      END_ERROR
    end
  end

  context 'with a different comment prefix' do
    let(:extractor) { described_class.new(comment_prefix: "//") }

    let(:input) { <<~END_INPUT }
      // begin-snippet: wakka
      This is the wakka snippet.
      // end-snippet
    END_INPUT

    it "works" do
      expect(subject['wakka']).to eq('This is the wakka snippet.')
    end
  end
end
