require 'rails_helper'

describe CandidatesController do

  describe 'GET /index' do
    before do
      get :index
    end

    it { is_expected.to respond_with(200) }
  end
end
