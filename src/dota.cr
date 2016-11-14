require "yaml"
require "json"

require "./dota/utils/mapped"
require "./dota/api/status/*"
require "./dota/api/basic/*"
require "./dota/api/cosmetic/rarity"
require "./dota/api/match/*"
require "./dota/api/live_match/*"
require "./dota/*"
require "./dota/api/*"

module Dota
  class Dota
    property :configuration

    def self.api
      @@client ||= API::Client.new
    end

    def self.configure(&block : Configuration -> _)
      api.configure(&block)
    end

    def self.configuration
      api.configuration
    end
  end
end
