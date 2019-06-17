require 'net/http'
require 'net/https'
require 'uri'
require 'open-uri'
require 'json'
require 'csv'

module TalkpushUpdater
  extend self

  class Error < StandardError; end

  SPREADSHEET_URL = ENV['SPREADSHEET_URL'].freeze

  attr_reader :candidates

  def update_candidates_list
    @candidates = fetch_spreadsheet_candidates
    candidates.each do |candidate|
      create_candidate(
        first_name: candidate['First Name'],
        last_name: candidate['Last Name'],
        email: candidate['Email'],
        phone: candidate['Phone number']
      )
    end
  end

  private

  def fetch_spreadsheet_candidates
    csv_file = open('talkpush.csv', 'wb') { |file| file << open(SPREADSHEET_URL).read }
    ::CSV.read(csv_file, headers: true).select {|row| row if row['Email']}
  end

  def create_candidate(*args)
    candidate = Candidate.find_or_initialize_by(*args)
    unless candidate.persisted?
      create_on_talkpush(*args)
      candidate.save!
    end
  end

  def create_on_talkpush(*candidate_data)
    header = {'Content-Type': 'application/json', 'Cache-Control': 'no-cache'}

    uri = URI.parse("https://my.talkpush.com/api/talkpush_services/campaigns/#{ENV['TALKPUSH_CAMPAIGN']}/campaign_invitations")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = data(*candidate_data).to_json

    response = http.request(request)
    raise Error if response.code != "200"
  rescue => _e
    raise Error
  end

  def data(first_name:, last_name:, email:, phone:)
    {
      api_key: ENV['TALKPUSH_API_KEY'],
        api_secret: ENV['TALKPUSH_API_SECRET'],
      campaign_invitation: {
        first_name: first_name,
        last_name: last_name,
        email: email,
        user_phone_number: phone
      }
    }
  end
end
