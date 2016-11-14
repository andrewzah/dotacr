module Dota
  module API
    class LiveMatchesList
      JSON.mapping(
        liveMatches: {key: "games", type: Array(LiveMatch)}
      )
    end

    class LiveMatch
      JSON.mapping(
        players: Array(SimplePlayer),
        match_id: Int64,
        lobby_id: Int64,
        spectators: Int32,
        series_id: Int32,
        game_number: Int32,
        league_id: Int32,
        stream_delay_s: Int32,
        radiant_series_wins: Int32,
        dire_series_wins: Int32,
        series_type: Int8,
        league_series_id: Int32,
        league_game_id: Int32,
        stage_name: String,
        league_tier: League::Tiers,
        dire_team: {type: SimpleTeam, nilable: true},
        radiant_team: {type: SimpleTeam, nilable: true},
        scoreboard: {type: Scoreboard, nilable: true}
      )

      def id
        @match_id
      end

      def roshan_timer
        @scoreboard["roshan_respawn_timer"]
      end

      def radiant
        if scoreboard = @scoreboard
          return scoreboard.radiant
        end
      end

      def dire
        if scoreboard = @scoreboard
          return scoreboard.dire
        end
      end

      class SimplePlayer
        include Dota::API::PlayerStatus
        JSON.mapping(
          account_id: Int32,
          name: String,
          hero_id: Int32,
          team: Teams
        )
      end

      class SimpleTeam
        include Dota::API::Converters

        JSON.mapping(
          name: {key: "team_name", type: String},
          id: {key: "team_id", type: Int64},
          logo: {key: "team_logo", type: String, converter: LogoConverter},
          complete: Bool
        )
      end

      class Scoreboard
        JSON.mapping(
          duration: Float32,
          roshan_respawn_timer: Int16,
          radiant: Side,
          dire: Side
        )
      end
    end
  end
end
