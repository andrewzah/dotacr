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
        dire_team: {type: Team, nilable: true},
        radiant_team: {type: Team, nilable: true},
        scoreboard: {type: Scoreboard, nilable: true}
      )

      def id
        @match_id
      end

      def roshan_timer
        @scoreboard["roshan_respawn_timer"]
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

      class Team
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

      class Side
        include Dota::API::MatchStatus

        class Pick
          JSON.mapping(hero_id: Int32)
        end

        class Ban
          JSON.mapping(hero_id: Int32)
        end

        class Ability
          JSON.mapping(
            ability_id: Int32,
            ability_level: Int8
          )
        end

        JSON.mapping(
          score: Int32,
          tower_state: Towers,
          barracks_state: Barracks,
          picks: {type: Array(Pick), nilable: true},
          bans: {type: Array(Ban), nilable: true},
          players: Array(LivePlayer),
          abilities: {type: Array(Ability), nilable: true}
        )
      end

      class LivePlayer
        JSON.mapping(
          account_id: Int64,
          player_slot: Int32,
          hero_id: Int32,
          level: Int8,
          kills: Int16,
          deaths: {key: "death", type: Int16},
          assists: Int16,
          last_hits: Int16,
          denies: Int16,
          gold: Int32,
          gold_per_min: Int16,
          xp_per_min: Int32,
          ultimate_state: Int32,
          ultimate_cooldown: Int32,
          respawn_timer: Int32,
          position_x: Float32,
          position_y: Float32,
          net_worth: Int32,
          item0_id: {type: Int16, key: "item0"},
          item1_id: {type: Int16, key: "item1"},
          item2_id: {type: Int16, key: "item2"},
          item3_id: {type: Int16, key: "item3"},
          item4_id: {type: Int16, key: "item4"},
          item5_id: {type: Int16, key: "item5"}
        )

        def items
          [
            item0_id, item1_id, item2_id,
            item3_id, item4_id, item5_id,
          ].map { |id| Item.new(id.to_i32) }
        end
      end
    end
  end
end
