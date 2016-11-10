module Dota
  module API
    class Hero
      include Utilities::Mapped
      extend Utilities::Mapped

      getter id : Int32, name : String
      private getter internalName : String

      def self.find(id)
        if mapping["#{id}"]?
          new(id)
        else
          raise Exception.new("Hero does not exist")
        end
      end

      def initialize(id : Int32)
        @id = id
        @internalName = mapping["#{id}"][0].to_s
        @name = mapping["#{id}"][1].to_s
      end

      def image_url(type = :full)
        # Possible values for type:
        # :full - full quality horizontal portrait (256x114px, PNG)
        # :lg - large horizontal portrait (205x11px, PNG)
        # :sb - small horizontal portrait (59x33px, PNG)
        # :vert - full quality vertical portrait (234x272px, JPEG)

        "http://cdn.dota2.com/apps/dota2/images/heroes/#{@internal_name}_#{type}.#{type == :vert ? "jpg" : "png"}"
      end
    end
  end
end
