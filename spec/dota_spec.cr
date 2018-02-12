require "./spec_helper"

describe Dota do
  it "initializes" do
    api = Dota::Dota.new
    api.should be_truthy
  end

  it "configures" do
    Dota::Dota.configure do |config|
      config.api_key = "xx"
    end
    Dota::Dota.configuration.api_key.should eq "xx"
  end

  # Set up API with Travis env vars
  Dota::Dota.configure do |config|
    config.api_key = ENV["DOTA_API_KEY"]
  end
  api = Dota::Dota.api

  describe "yaml parsing" do
    it "gets item" do
      item = api.item(13)
      item.id.should eq 13
      item.name.should eq "Gauntlets of Strength"
    end

    it "gets items" do
      items = api.items
      puts items.size.should eq 276
    end

    it "gets hero" do
      hero = api.hero(13)
      hero.id.should eq 13
      hero.name.should eq "Puck"
    end

    it "gets heroes" do
      heroes = api.heroes
      heroes.size.should eq 113
    end

    it "gets ability" do
      ability = api.ability(5003)
      ability.name.should eq "Mana Break"
      ability.fullName.should eq "Antimage Mana Break"
    end

    it "gets abilities" do
      abilities = api.abilities
      abilities.size.should eq 1000
    end
  end

  describe "client requests" do
    it "gets last match" do
      api.last_match(68351653).should be_a Dota::API::BasicMatch
    end

    # no idea why this is failing
    #it "gets leagues" do
    #  api.leagues.should be_a Array(Dota::API::League)
    #end

    it "gets live matches" do
      api.live_matches.should be_a Array(Dota::API::LiveMatch)
    end

    it "gets friends" do
      friends = api.friends(76561198052976237)
      friends.should be_a Array(Dota::API::Friend)
    end

    it "gets cosmetic rarities" do
      rarities = api.cosmetic_rarities
      rarities.should be_a Array(Dota::API::Cosmetic::Rarity)
      rarities.size.should eq 8
      rarities[0].name.should eq "common"
    end

    it "gets match" do
      m = api.match(789645621)

      m.match_id.should eq 789645621
      m.radiant_win.should eq true
      m.duration.should eq 908
      m.start_time.should eq 1405973570
      m.match_seq_num.should eq 709365483
      m.tower_status_radiant.should eq Dota::API::MatchStatus::Towers.new(2039_i64)
      m.tower_status_dire.should eq Dota::API::MatchStatus::Towers.new(1974_i64)
      m.first_blood_time.should eq 33
      m.lobby_type.should eq Dota::API::MatchStatus::LobbyTypes::Tournament
      m.cluster.should eq 111
      m.human_players.should eq 10
      m.leagueid.should eq 600
      m.radiant_team_id.should eq 1375614
      m.radiant_name.should eq "Newbee"
      m.radiant_logo.should eq "351645122255494137"
      m.radiant_team_complete.should eq 1
      m.dire_team_id.should eq 726228
      m.dire_name.should eq "Vici Gaming"
      m.dire_logo.should eq "35248220277958798"
      m.dire_team_complete.should eq 1
      m.radiant_captain.should eq 98887913
      m.dire_captain.should eq 91698091

      m.picks_bans.should be_a Array(Dota::API::Match::Draft)
      describe "draft" do
        draft = m.picks_bans.not_nil!
        draft[0].is_pick.should eq false
        draft[0].hero_id.should eq 15
        draft[0].order.should eq 0
        draft[0].team.should eq Dota::API::PlayerStatus::Teams::Radiant
      end

      m.players.should be_a Array(Dota::API::Match::Player)
      describe "player" do
        player = m.players.not_nil![0]
        player.account_id.should eq 98887913
        player.player_slot.should eq 0
        player.hero_id.should eq 69
        player.kills.should eq 2
        player.deaths.should eq 1
        player.assists.should eq 13
        player.leaver_status.should eq Dota::API::PlayerStatus::Status::Played
        player.last_hits.should eq 45
        player.denies.should eq 0
        player.gold_per_min.should eq 437
        player.xp_per_min.should eq 460
        player.item0_id.should eq 1
        player.item1_id.should eq 34
        player.item2_id.should eq 0
        player.item3_id.should eq 79
        player.item4_id.should eq 214
        player.item5_id.should eq 38
      end
    end

    it "gets matches with options set to default" do
      ms = api.matches.not_nil!
      ms.should be_truthy
      ms.size.should eq 100
      ms.should be_a Array(Dota::API::BasicMatch)

      describe "basic match" do
        bm = ms[0]
        bm.should be_a Dota::API::BasicMatch
        bm.match_id.should be > 0
        bm.match_seq_num.should be > 0
        bm.players.should be_a Array(Dota::API::BasicPlayer)
      end
    end

    it "gets matches with options" do
      describe "limit" do
        ms = api.matches({"limit" => 5}).not_nil!
        ms.size.should eq 5
      end

      describe "limit and tournament only" do
        ms = api.matches({"limit" => 4, "league_only" => true}).not_nil!
        ms.size.should eq 4
      end
    end
  end
end
