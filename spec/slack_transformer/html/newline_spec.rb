require 'slack_transformer/html/newline'


RSpec.describe SlackTransformer::Html::Newline do
    let(:transformation) { described_class.new(input) }
  
    describe '#to_slack' do
     
      context 'when <br> tag exist' do
        let(:input) { '<br>newline' }
  
        it 'just add a newline at the beginning' do
          expect(transformation.to_slack).to eq("\nnewline")
        end
      end

      context 'when <br/> tag exist' do
        let(:input) { '<br/>newline' }
  
        it 'just add a newline at the beginning' do
          expect(transformation.to_slack).to eq("\nnewline")
        end
      end

      context 'when <br></br> tag exist' do
        let(:input) { '<br>newline</br>' }
  
        it 'just add a newline at the beginning' do
          expect(transformation.to_slack).to eq("\nnewline")
        end
      end
  
    end
  end
  