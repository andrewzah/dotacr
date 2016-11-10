module Dota
  module API
    class FriendsList
      JSON.mapping(
        friends: Array(Friend)
      )
    end

    class Friend
      JSON.mapping(
        steamid: String,
        relationship: String,
        friend_since: Int32
      )
    end
  end
end
