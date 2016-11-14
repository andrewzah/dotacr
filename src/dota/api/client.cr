require "cossack"
require "http"

module Dota
  module API
    class Client
      @configuration : Configuration?

      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        yield configuration
      end

      def item(id)
        Item.new(id)
      end

      def items
        Item.all
      end

      def hero(id)
        Hero.find(id)
      end

      def heroes
        Hero.all
      end

      def ability(id)
        Ability.new(id)
      end

      def abilities
        Ability.all
      end

      def team(teamID : Int32)
        options = {
          "start_at_team_id" => teamID,
          "teams_requested"  => 1,
        }
        response = get("GetTeamInfoByTeamID", TeamsList, "IDOTA2Match_570", options)
        if response.teams.size > 0
          response.teams[0]
        end
      end

      def teams(options = {} of String => Int32)
        options["teams_requested"] = options.delete("limit").not_nil! if options.has_key?("limit")
        options["start_at_team_id"] = options.delete(:after).not_nil! if options.has_key?("after")

        response = get("GetTeamInfoByTeamID", TeamsList, "IDOTA2Match_570", options)
        response.teams if response.teams.size > 0
      end

      def match(matchID : Int32)
        response = get("GetMatchDetails", Match, "IDOTA2Match_570", {"match_id" => matchID})
      end

      # Gets basic matches. For a closer analysis, use #match_detail
      def matches(options = {} of String => Int32 | Bool)
        # the remapping is to make user input more friendly. e.g. date_min -> from.
        options["game_mode"] = options.delete("mode_id").not_nil! if options.has_key?("mode_id")
        options["skill"] = options.delete("skill_level").not_nil! if options.has_key?("skill_level")
        options["date_min"] = options.delete("from").not_nil! if options.has_key?("from")
        options["date_max"] = options.delete("to").not_nil! if options.has_key?("to")
        options["account_id"] = options.delete("player_id").not_nil! if options.has_key?("player_id")
        options["start_at_match_id"] = options.delete("after").not_nil! if options.has_key?("after")
        options["matches_requested"] = options.delete("limit").not_nil! if options.has_key?("limit")
        options["tournament_games_only"] = options.delete("league_only").not_nil! if options.has_key?("league_only")

        response = get("GetMatchHistory", BasicMatchesList, "IDOTA2Match_570", options)
        response.matches if response.matches.size > 0
      end

      def leagues(options = {"language" => "en"})
        response = get("GetLeagueListing", LeaguesList, "IDOTA2Match_570", options)
        response.leagues if response.leagues.size > 0
      end

      def live_matches(options = {} of String => Int32 | String)
        response = get("GetLiveLeagueGames", LiveMatchesList, "IDOTA2Match_570", options)
        response.liveMatches if response.liveMatches.size > 0
      end

      def cosmetic_rarities(options = {"language" => "en"})
        response = get("GetRarities", Cosmetic::RaritiesList, "IEconDOTA2_570", options)
        response.rarities
      end

      def friends(user_id)
        response = get("GetFriendList", FriendsList, "ISteamUser", {"steamid" => user_id})
        response.friends if response.friends.size > 0
      end

      def get(method, klass, interface, params)
        do_request(method, klass, interface, params)
      end

      private def do_request(method,
                             klass : T.class,
                             interface = "IDOTA2Match_570",
                             params = {} of String => String) : T forall T
        method_version = params.delete(:api_version) || configuration.api_version
        url = "https://api.steampowered.com/#{interface}/#{method}/#{method_version}"
        stringParams = {"key" => configuration.api_key.as(String)}
        params.each { |k, v| stringParams[k] = "#{v}" }

        @cossack = Cossack::Client.new(url)
        response = @cossack.not_nil!.get("", stringParams)
        body = response.body

        # This catches typos in interface names,
        # etc. However some responses respond with
        # missing in the JSON content, but a 200
        # status code
        if response.status != 200
          case response.status
          when 400...499
            raise ClientErrorException.new("#{response.status}: #{response.body}")
          when 500...599
            raise ServerErrorException.new("#{response.status}: #{response.body}")
          end
        end

        # Lazy, lazy valve is not consistent
        # the root key is different among interfaces.
        if interface == "ISteamUser"
          body = response.body.sub("friendslist", "result")
        end

        object = Response(T | ErrorResponse).from_json body
        result = object.result
        raise ResponseException.new(result.error) if result.is_a?(ErrorResponse)
        result
      end

      # For those who want a JSON::Any object to do their bidding with.
      def get_JSON_any(method, interface, params)
        do_request_JSON(method, interface, params)
      end

      private def do_request_JSON(method, interface = "IDOTA2Match_570", params = {} of String => String)
        method_version = params.delete(:api_version) || configuration.api_version
        url = "https://api.steampowered.com/#{interface}/#{method}/#{method_version}"
        stringParams = {"key" => configuration.api_key.as(String)}
        params.each { |k, v| stringParams[k] = "#{v}" }

        @cossack = Cossack::Client.new(url)
        response = @cossack.not_nil!.get("", stringParams)

        if response.status != 200
          case response.status
          when 400...499
            raise ClientErrorException.new("#{response.status}: #{response.body}")
          when 500...599
            raise ServerErrorException.new("#{response.status}: #{response.body}")
          end
        end

        JSON.parse(response.body)
      end
    end
  end
end
