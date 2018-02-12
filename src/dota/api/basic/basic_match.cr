module Dota
  module API
    include MatchStatus

    class BasicMatchesList
      JSON.mapping(
        status: Int32,
        num_results: Int32,
        total_results: Int32,
        results_remaining: Int32,
        matches: Array(BasicMatch)
      )
    end

    class BasicMatch
      JSON.mapping(
        match_id: Int64,
        match_seq_num: Int64,
        start_time: Int32,
        lobby_type: LobbyTypes,
        radiant_team_id: Int32,
        dire_team_id: Int32,
        players: Array(BasicPlayer)
      )
    end
  end
end
