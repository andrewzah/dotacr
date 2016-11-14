module Dota
  module API
    class LiveMatch
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
    end
  end
end
