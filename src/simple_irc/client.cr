module SimpleIrc
  class Client
    def initialize(
      @token : String,
      @nick : String,
      @channel : String,
      @host : String = "irc.chat.twitch.tv",
      @port : Int32 = 6697,
      @ssl : Bool = true
    )

      tcp_socket = TCPSocket.new(host, port)
      if @ssl
        @client = OpenSSL::SSL::Socket::Client.new(tcp_socket)
      else
        @client = tcp_socket
      end
    end

    def authenticate
      @client.puts("PASS #{@token}")
      @client.puts("NICK #{@nick}")
    end

    def join
      @client.puts("JOIN ##{@channel}")
    end

    def quit
      @client.puts("QUIT")
      @client.flush
      @client.close
    end

    def privmsg(msg : String, *receivers) # TODO: Make it flexible with regard to receivers.
      @client.puts("PRIVMSG ##{@channel} :#{msg}")
      @client.flush
    end
    
  end
end