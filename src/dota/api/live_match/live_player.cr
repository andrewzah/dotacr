module Dota
  module API
    class LiveMatch
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
          item5_id: {type: Int16, key: "item5"},
          name: {type: String, nilable: true}
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
