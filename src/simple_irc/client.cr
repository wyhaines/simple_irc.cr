require "openssl"

module SimpleIrc
  class Client
    getter client : OpenSSL::SSL::Socket::Client? | TCPSocket

    def initialize(
      @token : String,
      @nick : String,
      @channel : String,
      @host : String = "irc.chat.twitch.tv",
      @port : Int32 = 6697,
      @ssl : Bool = true,
      do_connect : Bool = true
    )
      if do_connect
        connect
      else
        @client = nil
      end
    end

    def connect
      tcp_socket = TCPSocket.new(@host, @port)
      if @ssl
        @client = OpenSSL::SSL::Socket::Client.new(tcp_socket)
      else
        @client = tcp_socket
      end
    end

    def authenticate
      @client.try do |client|
        client.puts("PASS #{@token}")
        client.puts("NICK #{@nick}")
      end
    end

    def join
      @client.try do |client|
        client.puts("JOIN ##{@channel}")
      end
    end

    def quit
      @client.try do |client|
        client.puts("QUIT")
        client.flush
        client.close
      end
    end

    def privmsg(msg : String, *receivers) # TODO: Make it flexible with regard to receivers.
      @client.try do |client|
        client.puts("PRIVMSG ##{@channel} :#{msg}")
        client.flush
      end
    end

    def gets
      @client.try do |client|
        client.gets
      end
    end

    def direct(msg)
      @client.try do |client|
        client.puts msg
      end
    end

  end
end
