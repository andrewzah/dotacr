module Dota
  module API
    class TeamsList
      JSON.mapping(
        status: Int8,
        teams: Array(Team)
      )
    end

    class Team
      JSON.mapping(
        name: String,
        tag: String,
        time_created: Int32,
        calibration_games_remaining: Int8,
        logo: Int64,
        logo_sponsor: Int64,
        country_code: String,
        url: String,
        games_played: Int16,
        admin_account_id: Int32,
        player_0_account_id: {type: Int32, nilable: true},
        player_1_account_id: {type: Int32, nilable: true},
        player_2_account_id: {type: Int32, nilable: true},
        player_3_account_id: {type: Int32, nilable: true},
        player_4_account_id: {type: Int32, nilable: true},
        player_5_account_id: {type: Int32, nilable: true},
        player_6_account_id: {type: Int32, nilable: true}
      )
    end
  end
end
