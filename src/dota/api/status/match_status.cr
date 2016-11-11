module Dota
  module API
    module MatchStatus
      @[Flags]
      enum Towers : Int64
        AncientTop
        AncientBottom
        BottomTier3
        BottomTier2
        BottomTier1
        MiddleTier3
        MiddleTier2
        MiddleTier1
        TopTier3
        TopTier2
        TopTier1

        def self.new(pull : JSON::PullParser)
          Towers.new(pull.read_int)
        end
      end

      @[Flags]
      enum Barracks : Int64
        BottomRanged
        BottomMelee
        MiddleRanged
        MiddleMelee
        TopRanged
        TopMelee

        def self.new(pull : JSON::PullParser)
          Barracks.new(pull.read_int)
        end
      end

      enum Types
        Invalid           = -1
        PublicMatchmaking
        Practice
        Tournament
        Tutorial
        CoopWithBots
        TeamMatch
        SoloQueue
        Ranked
        SoloMid1v1
      end

      enum GameModes
        None
        AllPick
        CaptainsMode
        RandomDraft
        SingleDraft
        AllRandom
        Intro
        Diretide
        ReverseCaptainsMode
        TheGreeviling
        Tutorial
        MidOnly
        LeastPlayed
        LimitedHeroPool
        CompendiumMatchmaking
        Custom
        CaptainsDraft
        BalancedDraft
        AbilityDraft
        Event
        AllRandomDeathMatch
        SoloMid1v1
        RankedAllPick
      end

      enum SkillLevels
        Any
        Normal
        High
        VeryHigh
      end
    end
  end
end
