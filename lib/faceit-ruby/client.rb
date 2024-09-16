require "faraday"

require "faceit-ruby/response"
require "faceit-ruby/api_error"
require "faceit-ruby/player"
require "faceit-ruby/game"
require "faceit-ruby/organizer"
require "faceit-ruby/team"
require "faceit-ruby/tournament"


module Faceit
  class Client
    #init
    API_ENDPOINT = "https://open.faceit.com/".freeze

    def initialize(api_key: nil)
      if api_key.nil?
        raise "An APIKEY is required to create client"
      end

      headers = {
        "User-Agent": "face-it-ruby client"
      }
      unless api_key.nil?
        api_key = api_key.gsub(/^Bearer /, "")
        headers["Authorization"] = "Bearer #{api_key}"
      end

      @conn = Faraday.new(API_ENDPOINT, { headers: headers }) do |faraday|
        faraday.request :json
        faraday.response :json
        faraday.adapter Faraday.default_adapter
      end
    end

    #Players
    def get_player(player_id)
      get_data("players/#{player_id}", {})
    end

    def get_player_by_nickname(nickname)
      get_data("players?nickname=#{nickname}", {})
    end

    def get_player_history(player_id, game_id, options = {})
      get_data("players/#{player_id}/history?game=#{game_id}", options)
    end

    def get_player_stats(player_id, game_id)
      get_data("players/#{player_id}/stats/#{game_id}", {})
    end

    #Games
    def get_games(game_id)
      if game_id.present?
        get_data("games/#{game_id}", {})
      else
        res = get_data("games", {})
        games = res['items'].map { |g| Game.new(g) }
        Response.new(games)
      end
    end

    #MATCHES
    def get_match(match_id)
      get_data("matches/#{match_id}", {})
    end

    def get_match_stats(match_id)
      get_data("matches/#{match_id}/stats", {})
    end

    #DOWNLOADS
    def get_download_url(resource_url)
      post("download/v2/demos/download", { "resource_url": resource_url })
    end


    #SEARCHES
    def search_organizers(options = {})
      res = get_data("search/organizers", options)

      organizers = res['items'].map { |g| Organizer.new(g) }
      Response.new(organizers)
    end

    def search_players(options = {})
      res = get_data("search/players", options)

      players = res['items'].map { |g| Player.new(g) }
      Response.new(players)
    end

    def search_teams(options = {})
      res = get_data("search/teams", options)

      teams = res['items'].map { |g| Team.new(g) }
      Response.new(teams)
    end

    def search_tournaments(options = {})
      res = get_data("search/tournaments", options)

      tournaments = res['items'].map { |g| Tournament.new(g) }
      Response.new(tournaments)
    end

    private
    def get(resource, params)
      http_res = @conn.get(resource, params)
      finish(http_res)
    end


    def get_data(resource, params)
      http_res = @conn.get("data/v4/#{resource}", params)
      finish(http_res)
    end


    def post(resource, params)
      http_res = @conn.post(resource, params)
      finish(http_res)
    end

    def post_data(resource, params)
      http_res = @conn.post("data/v4/#{resource}", params)
      finish(http_res)
    end

    def put(resource, params)
      http_res = @conn.put(resource, params)
      finish(http_res)
    end

    def put_data(resource, params)
      http_res = @conn.put("data/v4/#{resource}", params)
      finish(http_res)
    end

    def finish(http_res)
      unless http_res.success?
        raise ApiError.new(http_res.status, http_res.body)
      end

      http_res.body
    end
  end
end
