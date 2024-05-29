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
        let(:input) { 'Hello<p></p>World<p></p>' }
        
        it 'return World on a newline' do
          expect(transformation.to_slack).to eq("Hello\nWorld\n")
        end
      end



      context '<p></p>Hello<p></p><p></p><p></p>World' do
        let(:input) { '<p></p>Hello<p></p><p></p><p></p>World' }
        
        it 'return World on a newline' do
          expect(transformation.to_slack).to eq("Hello\nWorld")
        end
      end


      
  
     
    end
  end
  