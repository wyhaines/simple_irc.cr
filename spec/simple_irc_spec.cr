require "./spec_helper"

class Container
  class_property irc : SimpleIrc::Client?
  class_property connection : TCPSocket?
end

describe SimpleIrc do
  it "can connect to a server" do
    Container.irc = SimpleIrc::Client.new(
      token: "token",
      nick: "nick",
      channel: "channel",
      host: "127.0.0.1",
      port: Server.local_address.port,
      ssl: false
    )

    Container.connection = ServerConnections.receive

    Container.irc.try(&.class).should eq SimpleIrc::Client
    Container.connection.try(&.class).should eq TCPSocket
  end

  it "can authenticate" do
    spawn(name: "send authenticate") do
      Container.irc.try(&.authenticate)
    end

    Container.connection.try(&.gets).should eq "PASS token"
    Container.connection.try(&.gets).should eq "NICK nick"
  end

  it "can join" do
  end

  it "can quit" do
  end

  it "can send a private message" do
  end

  it "can read a line" do
    line = nil
    received = Channel(Nil).new
    spawn(name: "it can read a line") do
      line = Container.irc.try(&.gets)
      received.send(nil)
    end

    timeout(3) do
      Container.connection.try(&.puts("This is a test."))
      received.receive

      line.should eq "This is a test."
    end
  end

  it "can send a line" do
  end
end
