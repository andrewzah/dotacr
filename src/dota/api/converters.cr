module Dota
  module API
    module Converters
      module LogoConverter
        def self.from_json(parser : JSON::PullParser) : String
          parser.read_raw.to_s
        end
      end
    end
  end
end
