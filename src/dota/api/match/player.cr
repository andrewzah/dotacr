module Dota
  module API
    class Match
      class Player < BasicPlayer
        include Dota::API::PlayerStatus

        JSON.mapping(
          account_id: {type: Int64, nilable: true},
          player_slot: Int16,
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
