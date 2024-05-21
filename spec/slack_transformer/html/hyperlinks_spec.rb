require 'slack_transformer/html/hyperlinks'

RSpec.describe SlackTransformer::Html::Hyperlinks do
  let(:transformation) { described_class.new(input) }

  describe '#to_slack' do
    context 'when hyperlink text is present' do
      let(:input) { '<a href="test.com">test link</a>' }
      it 'replaces HTML a Tag with slack hyperlink' do
          expect(transformation.to_slack).to eq('<test.com|test link>')
      end
    end

    context 'when hyperlink text is not present' do
      let(:input) { '<a href="test.com"></a>' }
      it 'uses the href as the hyperlink text' do
        expect(transformation.to_slack).to eq('<test.com|test.com>')
      end
    end
  end
end
