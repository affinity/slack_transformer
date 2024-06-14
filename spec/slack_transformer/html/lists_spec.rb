require 'slack_transformer/html/lists'

RSpec.describe SlackTransformer::Html::Lists do
  let(:transformation) { described_class.new(input) }

  describe '#to_slack' do
    context 'when a list is unordered' do
      let(:input) { "<ul><li>foo</li><li>bar</li><li>baz</li></ul>" }

      it 'replaces the list' do
        expect(transformation.to_slack).to eq("• foo\n• bar\n• baz")
      end
    end

    context 'when a nested list is unordered' do
      let(:input) { "<ul><li>foo<ul><li>bar<ul><li>baz</li></ul></ul></ul>" }

      it 'replaces the list' do
        expect(transformation.to_slack).to eq("• foo\n\t• bar\n\t\t• baz")
      end
    end

    context 'when a list is ordered' do
      let(:input) { "<ol><li>foo</li><li>bar</li><li>baz</li></ol>" }

      it 'replaces the list' do
        expect(transformation.to_slack).to eq("1. foo\n2. bar\n3. baz")
      end
    end

    context 'when a nested list is ordered' do
      let(:input) { "<ol><li>foo<ol><li>bar<ol><li>baz</li></ol></ol></ol>" }

      it 'replaces the list' do
        expect(transformation.to_slack).to eq("1. foo\n\t1. bar\n\t\t1. baz")
      end
    end

    context 'when a list has multi-line' do
      let(:input) { "<ul><li>foo\nfoo1<ul><li>bar\nbar1</li></ul></ul>" }

      it 'replaces the list' do
        expect(transformation.to_slack).to eq("• foo\nfoo1\n\t• bar\n\tbar1")
      end
    end

    context 'when the html has other elements' do
      let (:input) { "<p>Test</p><ul><li>Bullet 1<ul><li>Nested Bullet <a>Link</a></li></ul></li></ul>"}

      it 'replaces the list' do
        expect(transformation.to_slack).to eq("<p>Test</p>• Bullet 1\n\t• Nested Bullet <a>Link</a>")
      end
    end
  end
end
