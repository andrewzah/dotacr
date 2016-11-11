module Dota
  module API
    class TeamsList
      JSON.mapping(
        status: Int8,
        teams: Array(Team)
      )
    end

    class Team
      include Dota::API::Converters

      JSON.mapping(
        name: String,
        tag: String,
        time_created: Int32,
        calibration_games_remaining: Int8,
        logo: {type: String, converter: LogoConverter},
        logo_sponsor: {type: String, converter: LogoConverter},
        country_code: String,
        url: String,
        games_played: Int16,
        admin_id: {key: "admin_account_id", type: Int32},
        player0_id: {key: "player_0_account_id", type: Int32, nilable: true},
        player1_id: {key: "player_1_account_id", type: Int32, nilable: true},
        player2_id: {key: "player_2_account_id", type: Int32, nilable: true},
        player3_id: {key: "player_3_account_id", type: Int32, nilable: true},
        player4_id: {key: "player_4_account_id", type: Int32, nilable: true},
        player5_id: {key: "player_5_account_id", type: Int32, nilable: true},
        player6_id: {key: "player_6_account_id", type: Int32, nilable: true},
      )

      def player_ids
        [
          player_0_account_id, player_1_account_id, player_2_account_id,
          player_3_account_id, player_4_account_id, player_5_account_id,
          player_6_account_id,
        ].compact_map &.itself
      end
    end
  end
end
