every 1.minutes do
  rake "talkpush:load_candidates", environment: 'development'
end
