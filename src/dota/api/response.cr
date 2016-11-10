module Dota
  module API
    class Response(T)
      JSON.mapping(
        result: T
      )
    end

    class ErrorResponse
      JSON.mapping(
        error: String
      )
    end
  end
end
