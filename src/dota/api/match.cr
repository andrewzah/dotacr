module Dota
  module API
    class Match
      include Dota::API::MatchStatus
      include Dota::API::PlayerStatus
      include Dota::API::Converters

      JSON.mapping(
        match_id: Int64,
        radiant_win: Bool,
        duration: Int32,
        pre_game_duration: Int32,
        start_time: Int32,
        match_seq_num: Int64,
        tower_status_radiant: Towers,
        tower_status_dire: Towers,
        barracks_status_radiant: Barracks,
        barracks_status_dire: Barracks,
        cluster: Int32,
        first_blood_time: Int32,
        lobby_type: GameModes,
        human_players: Int8,
        leagueid: Int32,
        positive_votes: Int32,
        negative_votes: Int32,
        game_mode: GameModes,
        flags: Int32,
        engine: Int32,
        radiant_score: Int32,
        dire_score: Int32,
        radiant_team_id: {type: Int32, nilable: true},
        radiant_name: {type: String, nilable: true},
        radiant_logo: {type: String, nilable: true, converter: LogoConverter},
        radiant_team_complete: {type: Int32, nilable: true},
        dire_team_id: {type: Int32, nilable: true},
        dire_name: {type: String, nilable: true},
        dire_logo: {type: String, nilable: true, converter: LogoConverter},
        dire_team_complete: {type: Int32, nilable: true},
        radiant_captain: {type: Int32, nilable: true},
        dire_captain: {type: Int32, nilable: true},
        picks_bans: {type: Array(Draft), nilable: true},
        players: {type: Array(Player), nilable: true}
      )

      def id
        @match_id
      end

      class Draft
        JSON.mapping(
          is_pick: Bool,
          hero_id: Int32,
          team: Teams,
          order: Int8
        )
      end

      class Player < BasicPlayer
        include Dota::API::PlayerStatus

        JSON.mapping(
          account_id: {type: Int64, nilable: true},
          player_slot: Int8,
          hero_id: Int8,
          kills: Int16,
          deaths: Int16,
          assists: Int16,
          leaver_status: Status,
          last_hits: Int16,
          denies: Int16,
          gold_per_min: Int16,
          xp_per_min: Int16,
          item0_id: {type: Int16, key: "item_0"},
          item1_id: {type: Int16, key: "item_1"},
          item2_id: {type: Int16, key: "item_2"},
          item3_id: {type: Int16, key: "item_3"},
          item4_id: {type: Int16, key: "item_4"},
          item5_id: {type: Int16, key: "item_5"}
        )
      end
    end
  end
end
