namespace :talkpush do
  desc "Update forecasts fields"

  task load_candidates: :environment do
    TalkpushUpdater.update_candidates_list
  end
end
