module Dota
  module API
    class Ability
      include Utilities::Mapped
      extend Utilities::Mapped

      getter id : Int32, name : String, fullName : String
      private getter internalName : String

      def initialize(id : Int32)
        @id = id
        @internalName = mapping["#{@id}"][0].to_s
        @name = mapping["#{@id}"][1].to_s
        @fullName = mapping["#{@id}"][2].to_s
      end

      def image_url(type = :lg)
        # Possible values for type:
        # :hp1 - 90x90 PNG image
        # :hp2 - 105x105 PNG image
        # :lg - 128x128 PNG image

        if @internalName == "stats"
          "https://steamcdn-a.akamaihd.net/apps/dota2/images/workshop/itembuilder/stats.png"
        else
          "http://cdn.dota2.com/apps/dota2/images/abilities/#{@internalName}_#{type}.png"
        end
      end
    end
  end
end
