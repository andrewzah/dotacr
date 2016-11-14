module Dota
  module API
    class BasicPlayer
      JSON.mapping(
        account_id: {type: Int64, nilable: true},
        player_slot: Int16,
        hero_id: Int8
      )
    end
  end
end
