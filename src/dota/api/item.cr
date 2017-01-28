module Dota
  module API
    class Item
      include Utilities::Mapped
      extend Utilities::Mapped

      getter id : Int32, name : String
      private getter internalName : String

      def initialize(id)
        @id = id
        map = mapping["#{id}"]
        @internalName = map[0].to_s
        @name = map[1].to_s
      end

      # Possible values for type:
      # :lg - 85x64 PNG image
      # :eg - 27x20 PNG image
      def image_url(type = :lg)
        filename = "#{@internalName.sub(/\Arecipe_/, "")}_#{type}.png"
        "http://cdn.dota2.com/apps/dota2/images/items/#{filename}"
      end
    end
  end
end
