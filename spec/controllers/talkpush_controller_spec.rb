require 'rails_helper'

describe TalkpushController do

  describe 'POST /load_candidates' do
    context 'when arequest is mde' do
      before do
        get :load_candidates
      end

      it { is_expected.to respond_with(302) }
    end

    context 'when there is an error on candidates load' do
      it 'returns an error message' do
        allow(TalkpushUpdater).to receive(:update_candidates_list).and_raise(TalkpushUpdater::Error)
        get :load_candidates
        expect(flash[:danger]).not_to be_nil
      end
    end

    context 'when there no error on candidates load' do
      it 'returns a success message' do
        allow(TalkpushUpdater).to receive(:update_candidates_list).and_return(true)
        get :load_candidates
        expect(flash[:success]).not_to be_nil
      end
    end
  end
end
