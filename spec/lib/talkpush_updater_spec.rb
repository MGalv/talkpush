require 'rails_helper'
require 'csv'

describe TalkpushUpdater do

  describe '#update_candidates_list' do
    context 'when talkpush api responds successfully' do
      before do
        response = Net::HTTPSuccess.new(1.0, '200', 'OK')
        allow_any_instance_of(Net::HTTP).to receive(:request).and_return(response)
        candidates = CSV.read(File.expand_path(File.dirname(__FILE__)) + '/../fixtures/talkpush.csv', headers: true)
        allow(TalkpushUpdater).to receive(:fetch_spreadsheet_candidates).and_return(candidates)
      end

      it 'adds the candidates to the database' do
        expect {
          TalkpushUpdater.update_candidates_list
        }.to change(Candidate, :count).by(2)
      end

      it 'does not add duplicated candidates to the database' do
        TalkpushUpdater.update_candidates_list

        expect {
          TalkpushUpdater.update_candidates_list
        }.to change(Candidate, :count).by(0)
      end

      it 'does not add duplicated candidates creation requests' do
        TalkpushUpdater.update_candidates_list
        expect(TalkpushUpdater).not_to receive(:create_on_talkpush)
        TalkpushUpdater.update_candidates_list
      end
    end

    context 'when talkpush api responds with an error' do
      before do
        response = Net::HTTPSuccess.new(1.0, '400', 'NOT OK')
        allow_any_instance_of(Net::HTTP).to receive(:request).and_return(response)
        candidates = CSV.read(File.expand_path(File.dirname(__FILE__)) + '/../fixtures/talkpush.csv', headers: true)
        allow(TalkpushUpdater).to receive(:fetch_spreadsheet_candidates).and_return(candidates)
      end

      it 'adds the candidates to the database' do
        expect {
          TalkpushUpdater.update_candidates_list
        }.to raise_error(TalkpushUpdater::Error)
        expect(Candidate.count).to eq(0)
      end

      it 'does not add duplicated candidates to the database' do
        expect {
          TalkpushUpdater.update_candidates_list
        }.to raise_error(TalkpushUpdater::Error)
      end
    end
  end
end
