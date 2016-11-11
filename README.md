# dotacr

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
                                        # :skill_level - Integer, In this skill level (ignored if :player_id is provided). See Dota::API::Match::SkillLevels
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

#### Custom Requests

For the unsupported endpoints, you can use `api.get`. For example, the following code is similar to `api.matches(789645621)` except it will return the raw JSON payload instead of an array of `Dota::Match`es.

```crystal
api.get(<Method>, <Class>, <Interface>, <Options Hash>)
api.get("GetMatchDetails", API::Match, "IDOTA2Match_570", {"match_id" => 789645621})
```

**Note**: For queries that return an array of objects, you must use the relative list class:
* Match => MatchesList
* BasicMatch => BasicMatchesList
* League => LeaguesList
* etc.

## API Objects

### Hero

```crystal
hero.id        # Int8, ID of the hero
hero.name      # String, Name of the hero
hero.image_url # String, URL of the hero portrait
```

### Item

```crystal
item.id        # Int32
item.name      # String
item.image_url # String
```

### Ability

```crystal
ability.id        # Int32
ability.name      # String -> "Beserker's Call"
ability.fullName  # String -> "Axe Beserker's Call"
```

### Team
TeamsList:

```crystal
list.status  # Int8
list.teams   # Array(Dota::API::Team)
```

```crystal
team.player_ids                   # Array(Int32)
team.name                         # String
team.tag                          # String
team.country_code                 # String, ISO 3166-1 country code (see http://en.wikipedia.org/wiki/ISO_3166-1#Current_codes)
team.admin_id                     # Integer, Team admin's 32-bit Steam ID
team.player_ids                   # Array[Integer], Players' 32-bit Steam IDs
team.logo                         # String, UGC ID of the team's logo
team.logo_sponsor                 # String, UGC ID of the team's logo
team.url                          # String, URL of the team's website
team.time_created                 # Int32
team.games_played                 # Int16
team.player0_id                   # Int32 | Nil
...
team.player6_id                   # Int32 | Nil
team.calibration_games_remaining  # Int8
```

#### League
`LeaguesList` has one member: `leagues: Array(Dota::API::League)`.

```crystal
league.id          # Int32
league.name        # String
league.description # String
league.url         # String
league.itemdef     # Int32

Dota::API::League::Tiers
enum Tiers
    Amateur      = 1
    Professional
    Premier
end
```

#### Match

Caveat: Getting a list of matches via `api.matches` will call [GetMatchHistory](https://wiki.teamfortress.com/wiki/WebAPI/GetMatchHistory) which has very few attributes for the matches returned (obviously for performance reasons), as opposed to getting info about a particular match via `api.matches(id)` which will instead call [GetMatchDetails](https://wiki.teamfortress.com/wiki/WebAPI/GetMatchDetails). The former uses `Dota::API::BasicMatch`, the latter uses `Dota::API::Match`.

#### Dota::API::BasicMatch
The response will always be `Dota::API::BasicMatchesList`, even if there are 0 results.

```crystal
list.status             # Int32
list.num_results        # Int32
list.total_results      # Int32
list.results_remaining  # Int32
list.matches            # Array(Dota::API::BasicMatch)
```

```crystal
basicMatch.match_id        # Int64
basicmatch.match_seq_num   # Int64
basicMatch.start_time      # Int32
basicMatch.lobby_type      # Dota::API::MatchStatus::GameModes
basicMatch.radiant_team_id # In32
basicMatch.dire_team_id    # Int32
basicMatch.players         # Array(Dota::API::BasicPlayer)
```

BasicPlayer:
```crystal
account_id    # Int64 | Nil
player_slot   # Int8
hero_id       # Int32
```

#### Dota::API::Match
`Dota::API::MatchesList` has one member: `matches: Array(Dota::API::Match)`.

```crystal
match.id                      # Int64
match.radiant_win             # Bool
match.duration                # Int32, Length of the match, in seconds since the match began
match.pre_game_duration       # Int32
match.start_time              # Int32
match.match_seq_num           # Int64
match.tower_status_radiant    # Enum, Dota::API::MatchStatus::Towers
match.tower_status_dire       # Enum, Dota::API::MatchStatus::Towers
match.barracks_status_radiant # Enum, Dota::API::MatchStatus::Barracks
match.barracks_status_dire    # Enum, Dota::API::MatchStatus::Barracks
match.cluster                 # Int32
match.first_blood_time        # Int32
match.lobby_type              # Enum, Dota::API::MatchStatus::GameModes
match.human_players           # Int8
match.leagueid                # Int32
match.positive_votes          # Int32
match.negative_votes          # Int32
match.game_mode               # Enum, Dota::API::MatchStatus::GameModes
match.flags                   # Int32
match.engine                  # Int32
match.radiant_score           # Int32,
match.dire_score              # Int32,
match.radiant_team_id         # Int32 | Nil
match.radiant_name            # String | Nil
match.radiant_logo            # String | Nil
match.radiant_team_complete   # Int32 | Nil
match.dire_team_id            # Int32 | Nil
match.dire_name               # String | Nil
match.dire_team_complete      # Int32 | Nil
match.radiant_captain         # Int32 | Nil
match.dire_captain            # Int32 | Nil
match.picks_bans              # Array(Dota::API::Match::Draft) | Nil, Picks and bans in the match, if the game mode is "Captains Mode"
match.players                 # Array(Dota::API::Match::Player) | Nil

# Dota::API::Match::Draft
draft.order          # Integer, 1-20
draft.pick?          # Boolean, true if the draft is a pick, and not a ban
draft.team           # Enum, Dota::API::PlayerStatus::Teams
draft.hero_id        # Int32

# Dota::API::Match::Player
player.account_id    # Int64
player.player_slot   # Int8
player.hero_id       # Int8
player.kills         # Int16
player.deaths        # Int16
player.assists       # Int16
player.leaver_status # Dota::API::PlayerStatus::Status
player.last_hits     # Int16
player.denies        # Int16
player.gold_per_min  # Int16
player.xp_per_min    # Int16
player.item0_id      # Int16
player.item1_id      # Int16
player.item2_id      # Int16
player.item3_id      # Int16
player.item4_id      # Int16
player.item5_id      # Int16
```

#### Live Matches
`Dota::API::LiveMatchesList` has one member: `liveMatches: Array(Dota::API::Match)`.

```crystal
live_match.radiant          # Dota::API::LiveMatch::Side, Info about the team on the Radiant side
live_match.dire             # Dota::API::LiveMatch::Side, Info about the team on the Dire side

live_match.id               # Int64
live_match.lobby_id         # Int64
live_match.spectators       # Int32
live_match.league_id        # Int32
live_match.stream_delay     # Int32, Number of seconds the stream is behind actual game time
live_match.series_type      # Int8, Best of X series
live_match.league_tier      # Enum, Dota::API::League::Tiers
live_match.duration         # Integer, Length of the match, in seconds since the match began
live_match.roshan_timer     # Int16
live_match.scoreboard       # Dota::API::LiveMatch::Scoreboard
live_match.players          # Array(Dota::API::LiveMatch::SimplePlayer)
live_match.dire_team        # Dota::API::LiveMatch::Team

SimplePlayer
sp.account_id               # Int64
sp.name                     # String
sp.hero_id                  # Int32
sp.team                     # Enum, Dota::API::PlayerStatus::Teams

Team
t.name                      # String
t.id                        # Int64
t.logo                      # String
t.complete                  # Bool

Scoreboard
sb.duration                 # Float32
sb.roshan_respawn_timer     # Int16
sb.radiant                  # Dota::API::LiveMatch::Side
sb.dire                     # Dota::API::LiveMatch::Side
```

### Side (Currently only used by LiveMatch)
```crystal
side.score           # Int32
side.tower_state     # Enum, Dota::API::MatchStatus::Towers
side.barracks_state  # Enum, Dota::API::MatchStatus::Barracks
side.picks           # Array(Pick) | Nil
side.bans            # Array(Bans) | Nil
side.players         # Array(LivePlayer)
side.abilities       # Array(Ability) | Nil

Pick
pick.hero_id         # Int32

Ban
ban.hero_id          # Int32

Ability
ablity_id            # Int32
ability_level        # Int8

LivePlayer
lp.account_id         # Int64
lp.player_slot        # Int8
lp.level              # Int8
lp.kills              # Int16
lp.deaths             # Int16
lp.assists            # Int16
lp.denies             # Int16
lp.gold               # Int32
lp.gold_per_min       # Int16
lp.xp_per_min         # Int16
lp.ultimate_state     # Int8
lp.ultimate_cooldown  # Int32
lp.respawn_timer      # Int32
lp.position_x         # Float32
lp.position_y         # Float32
lp.net_worth          # Int32
lp.item0_id           # Int16
...
lp.item5_id           # Int16
```

### Friends
`Dota::API::FriendsList` has one member: `friends: Array(Dota::API::Friend)`.

```crystal
friend.steamid  # String
friend.relationship    # String
friend.friend_since    # Int32
```

## Resources

- [vinnicc/dota](https://github.com/vinnicc/dota) The ruby version of this wrapper, and the inspiration behind it.
- [Steam-Powered DOTA on Rails](http://www.sitepoint.com/steam-powered-dota-on-rails/) and [DOTA 2 on Rails: Digging Deeper](http://www.sitepoint.com/dota-2-rails-digging-deeper/) by Ilya Bodrov-Krukowski - A tutorial for getting personal match statistics that makes use of this library for Steam integration. (www.sitepoint.com)
- [Things You Should Know Before Starting API Development](http://dev.dota2.com/showthread.php?t=58317) by MuppetMaster42 (dev.dota2.com)
- [Dota 2 WebAPI Wiki](https://wiki.teamfortress.com/wiki/WebAPI#Dota_2) (wiki.teamfortress.com)
- [Dota 2 WebAPI Forums](http://dev.dota2.com/forumdisplay.php?f=411) (dev.dota2.com)

## Contributing

1. Fork it ( https://github.com/azah/dotacr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [azah](https://github.com/azah) Andrew Zah - creator, maintainer
