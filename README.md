# dota

A Crystal client for the [DotA 2 API](https://wiki.teamfortress.com/wiki/WebAPI#Dota_2).

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  dota:
    github: azah/dotacr
```

## Usage


```crystal
require "dota"
```

Get your steam API key [here](https://steamcommunity.com/login/home/?goto=%2Fdev%2Fapikey), and configure Dotacr to use it:

```crystal
Dota.configure do |config|
  config.api_key = "abcxyz"

  # Set API version (defaults to "v1")
  # config.api_version = "v1"
end
```

Then use the client:

```crystal
api = Dota.api

api.hero(13)                            # => (Cached) A single hero - "Puck"
api.heroes                              # => (Cached) All heroes

api.item(114)                           # => (Cached) A single item - "Heart of Tarrasque"
api.items                               # => (Cached) All items

api.ability(5003)                       # => (Cached) A single ability - "Mana Break"
api.abilities                           # => (Cached) All abilities

api.team(1375614)                       # => A single team - "Newbee"
api.teams                               # => A list of teams

api.teams({"after" => 1375614})         # Allowed options:
                                        #
                                        # :after - Integer, With team IDs equal or greater than this
                                        # :limit - Integer, Amount of teams to return (default is 100)

api.leagues                             # => All leagues

api.matches(789645621)                  # => A single match - "Newbee vs Vici Gaming"
api.matches                             # => A list of matches
api.matches({"hero_id" => 43})          # Allowed options:
                                        #
                                        # :hero_id     - Integer, With this hero. See Dota::API::Hero.mapping
                                        # :after       - Integer, With match IDs equal or greater than this
                                        # :player_id   - Integer, With this player (32-bit Steam ID)
                                        # :league_id   - Integer, In this league. Use Dota.leagues to get a list of leagues
                                        # :mode_id     - Integer, In this game mode. See Dota::API::Match::MODES
                                        # :skill_level - Integer, In this skill level (ignored if :player_id is provided). See Dota::API::Match::SKILL_LEVELS
                                        # :from        - Integer, Minimum timestamp
                                        # :to          - Integer, Maximum timestamp
                                        # :min_players - Integer, With at least this number of players
                                        # :league_only - Boolean, Only league matches
                                        # :limit       - Integer, Amount of matches to return (default is 100)

api.live_matches                        # => All live league matches
api.live_matches({"league_id" => 600})  # Allowed options:
                                        #
                                        # :league_id - Integer, In this league. Use Dota.leagues to get a list of leagues
                                        # :match_id  - Integer, With this match

api.cosmetic_rarities                   # => All cosmetic rarities

api.friends(76561198052976237)           # => All friends of user
```

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/[your-github-name]/dota/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[your-github-name]](https://github.com/[your-github-name]) Andrew Zah - creator, maintainer
