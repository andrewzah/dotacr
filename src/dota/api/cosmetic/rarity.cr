module Dota
  module API
    module Cosmetic
      class RaritiesList
        JSON.mapping(
          count: Int8,
          rarities: Array(Rarity)
        )
      end

      class Rarity
        JSON.mapping(
          name: String,
          id: Int8,
          order: Int8,
          color: String,
          localized_name: String
        )
      end
    end
  end
end
