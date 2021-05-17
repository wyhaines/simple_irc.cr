require "spec"
require "../src/simple_irc"
require "timeout"

Server = TCPServer.new(
  host: "127.0.0.1",
  port: 0
)

ServerConnections = Channel(TCPSocket).new(10)

spawn(name: "Fake IRC") do
  loop do
    if socket = Server.accept
      ServerConnections.send(socket)
    else
      break
    end
  end
end
