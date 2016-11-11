module Dota
  module API
    module PlayerStatus
      enum Teams
        Radiant
        Dire
        Broadcaster
        Unassigned  = 4
      end

      enum Status
        Played
        Disconnected
        DisconnectedWithAbandon
        Abandoned
        AFK
        NeverConnected
        TimedOut
      end
    end
  end
end
