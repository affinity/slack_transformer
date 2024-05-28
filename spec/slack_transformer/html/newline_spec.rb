require 'slack_transformer/html/newline'


RSpec.describe SlackTransformer::Html::Newline do
    let(:transformation) { described_class.new(input) }
  
    describe '#to_slack' do
      context 'when a tag <p></p> exist' do
        let(:input) { '<p>new paragraph</p>' }
  
        it 'wrapping the content with \n' do
          expect(transformation.to_slack).to eq("\n new paragraph \n")
        end
      end

      context 'when only opening tag <p> exist' do
        let(:input) { '<p>new paragraph' }
  
        it 'wrapping the content with \n' do
          expect(transformation.to_slack).to eq("\n new paragraph \n")
        end
      end
  
      context 'when <br> tag exist' do
        let(:input) { '<br> newline' }
  
        it 'just add a newline in the beginning' do
          expect(transformation.to_slack).to eq("\n newline")
        end
      end

      context 'when <br/> tag exist' do
        let(:input) { '<br/> newline' }
  
        it 'just add a newine in teh beginning' do
          expect(transformation.to_slack).to eq("\n newline")
        end
      end

      context 'when <br></br> tag exist' do
        let(:input) { '<br> newline</br>' }
  
        it 'just add a newine in teh beginning' do
          expect(transformation.to_slack).to eq("\n newline")
        end
      end
  
    end
  end
  