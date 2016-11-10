module Dota
  class Configuration
    property api_key : String?
    getter api_version : String

    DEFAULT_API_VERSION = "v1"
    OPTIONS             = [API_KEY, API_VERSION]

    def initialize
      @api_version = DEFAULT_API_VERSION
    end
  end
end
