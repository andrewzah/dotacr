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

      def radiant
        Side.new(:radiant, @radiant_score, @barracks_status_radiant,
          @tower_status_radiant, @radiant_team_id, @radiant_name,
          @radiant_logo, @radiant_team_complete, @radiant_captain,
          @picks_bans, @players)
      end

      def dire
        Side.new(:dire, @dire_score, @barracks_status_dire,
          @tower_status_dire, @dire_team_id, @dire_name,
          @dire_logo, @dire_team_complete, @dire_captain,
          @picks_bans, @players)
      end

      class Draft
        JSON.mapping(
          is_pick: Bool,
          hero_id: Int32,
          team: Teams,
          order: Int8
        )
      end
    end
  end
end
