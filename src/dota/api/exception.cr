module Dota
  module API
    class ClientErrorException < Exception
    end

    class ServerErrorException < Exception
    end

    class ResponseException < Exception
    end
  end
end
