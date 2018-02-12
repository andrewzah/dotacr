module Dota
  module API
    class Match
      class Side
        getter score, barracks_status, tower_status, id, name
        getter logo, complete, captain, picks_bans, players

        def initialize(
          side : Symbol,
          @score : Int32,
          @barracks_status : Barracks,
          @tower_status : Towers,
          @team_id : Int32 | Nil = nil,
          @team_name : String | Nil = nil,
          @team_logo : String | Nil = nil,
          @team_complete : Int32 | Nil = nil,
          @team_captain : Int32 | Nil = nil,
          @picks_bans : Array(Draft) | Nil = nil,
          @players : Array(Player) | Nil = nil
        )
          @players = sort_players(side)
          @picks_bans = sort_picks_bans(side)
        end

        def sort_players(side : Symbol)
          if players = @players
            case side
            when :radiant
              players = players.reject { |player| (128..132).covers? player.player_slot }
            when :dire
              players = players.reject { |player| (0..4).covers? player.player_slot }
            end
            players
          end
        end

        def sort_picks_bans(side : Symbol)
          if picks_bans = @picks_bans
            case side
            when :radiant
              picks_bans = picks_bans.reject { |pb| pb.team != Teams::Radiant }
            when :dire
              picks_bans = picks_bans.reject { |pb| pb.team != Teams::Dire }
            end
            picks_bans
          end
        end
      end
    end
  end
end
