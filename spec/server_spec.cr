require "./spec_helper"

describe LSP::Server do
  it "can send a notification" do
    i = IO::Memory.new("")
    o = IO::Memory.new
    
    server = LSP::Server.new(i, o)
    
    msg = server.notify LSP::Message::ShowMessage do |msg|
      msg.params.message = "Hello, World!"
      msg
    end
    msg.params.message.should eq "Hello, World!"
    
    LSP::Wire.read_message(IO::Memory.new(o.to_s)).should eq msg
  end
  
  it "can send a request" do
    i = IO::Memory.new("")
    o = IO::Memory.new
    
    server = LSP::Server.new(i, o)
    
    msg = server.request LSP::Message::ShowMessageRequest do |msg|
      msg.params.message = "Hello, World!"
      msg
    end
    msg.params.message.should eq "Hello, World!"
    
    LSP::Wire.read_message(IO::Memory.new(o.to_s)).should eq msg
  end
  
  it "can receive a request and send a response" do
    outstanding = {} of (String | Int64) => LSP::Message::AnyRequest
    req = LSP::Message::Initialize.new(UUID.random.to_s)
    req.params.process_id = 42
    buf = IO::Memory.new
    LSP::Wire.write_message(buf, req, outstanding)
    
    i = IO::Memory.new(buf.to_s)
    o = IO::Memory.new
    
    server = LSP::Server.new(i, o)
    server.receive.should eq req
    
    msg = server.respond req do |msg|
      msg.result.capabilities.hover_provider.should eq false
      msg.result.capabilities.hover_provider = true
      msg
    end
    msg.result.capabilities.hover_provider.should eq true
    
    LSP::Wire.read_message(IO::Memory.new(o.to_s), outstanding).should eq msg
  end
end
