module Dota
  module API
    class LeaguesList
      property :leagues

      JSON.mapping(
        leagues: Array(League)
      )
    end

    class League
      JSON.mapping(
        leagueid: Int32,
        name: String,
        description: String,
        tournament_url: String,
        itemdef: Int32
      )

      def id
        @leagueid
      end

      enum Tiers
        Unknown      = 0
        Amateur
        Professional
        Premier
      end
    end
  end
end
