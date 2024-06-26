require 'slack_transformer/html/paragraph'


RSpec.describe SlackTransformer::Html::Paragraph do
    let(:transformation) { described_class.new(input) }

    describe '#to_slack' do
      context '<p>Hello World</p>' do
        let(:input) { '<p>Hello World</p>' }

        it 'return Hello World' do
           expect(transformation.to_slack).to eq('Hello World')
        end
      end

      context '<p>Hello</p><p>World</p>' do
        let(:input) { '<p>Hello</p><p>World</p>' }

        it 'return World on a newline' do
          expect(transformation.to_slack).to eq("Hello\nWorld")
        end
      end

      context 'Hello<p>World</p>Again' do
        let(:input) { 'Hello<p>World</p>Again' }

        it 'return World and Again on a newline' do
          expect(transformation.to_slack).to eq("Hello\nWorld\nAgain")
        end
      end

      context 'Hello<p>World</p>' do
        let(:input) { 'Hello<p>World</p>' }

        it 'return World on a newline' do
          expect(transformation.to_slack).to eq("Hello\nWorld")
        end
      end

      context '<p>Hello</p>World' do
        let(:input) { '<p>Hello</p>World' }

        it 'return World on a newline' do
          expect(transformation.to_slack).to eq("Hello\nWorld")
        end
      end

      context 'Hello<p></p>World' do
        let(:input) { 'Hello<p></p>World' }

        it 'return World on a newline' do
          expect(transformation.to_slack).to eq("Hello\nWorld")
        end
      end

      context 'Hello<p></p>World<p></p>' do
        let(:input) { 'Hello<p></p>World<p></p>Again' }

        it 'return World on a newline' do
          expect(transformation.to_slack).to eq("Hello\nWorld\nAgain")
        end
      end

      context '<p></p>Hello<p></p><p></p><p></p>World' do
        let(:input) { '<p></p>Hello<p></p><p></p><p></p>World' }

        it 'return World on a newline' do
          expect(transformation.to_slack).to eq("\nHello\n\n\nWorld")
        end
      end

      context 'P tag within a bullet point' do
        let(:input) { '<p>Hello</p><ul><li><p>Bullet</p></li></ul>' }

        it 'return World on a newline' do
          expect(transformation.to_slack).to eq("Hello\n<ul><li>Bullet</li></ul>")
        end
      end

      context 'P tag in front of bullet point' do
        let(:input) { "<p>Test</p>• Bullet 1\n\t• Nested Bullet <a>Link</a>" }

        it 'Add newline before bullet' do
          expect(transformation.to_slack).to eq("Test\n• Bullet 1\n\t• Nested Bullet <a>Link</a>")
        end
      end

      context 'Ignore empty content' do
        let(:input) { "<p>Hello</p> <p>World</p>"}
        it 'Only add one newline between' do
          expect(transformation.to_slack).to eq("Hello \nWorld")
        end
      end
    end
  end
