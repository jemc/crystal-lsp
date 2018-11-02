require "./spec_helper"

describe LSP::Wire do
  it "can send a notification" do
    i = IO::Memory.new("")
    o = IO::Memory.new
    
    server = LSP::Wire.new(i, o)
    
    msg = server.notify LSP::Message::ShowMessage do |msg|
      msg.params.message = "Hello, World!"
      msg
    end
    msg.params.message.should eq "Hello, World!"
    
    LSP::Codec.read_message(IO::Memory.new(o.to_s)).should eq msg
  end
  
  it "can send a request" do
    i = IO::Memory.new("")
    o = IO::Memory.new
    
    server = LSP::Wire.new(i, o)
    
    msg = server.request LSP::Message::ShowMessageRequest do |msg|
      msg.params.message = "Hello, World!"
      msg
    end
    msg.params.message.should eq "Hello, World!"
    
    LSP::Codec.read_message(IO::Memory.new(o.to_s)).should eq msg
  end
  
  it "can receive a request and send a response" do
    i, send_i = IO.pipe
    from_o, o = IO.pipe
    
    req = LSP::Message::Initialize.new(UUID.random.to_s)
    req.params.process_id = 42
    outstanding = {} of (String | Int64) => LSP::Message::AnyRequest
    
    LSP::Codec.write_message(send_i, req, outstanding)
    
    server = LSP::Wire.new(i, o)
    server.receive.should eq req
    
    msg = server.respond req do |msg|
      msg.result.capabilities.hover_provider.should eq false
      msg.result.capabilities.hover_provider = true
      msg
    end
    msg.result.capabilities.hover_provider.should eq true
    
    LSP::Codec.read_message(from_o, outstanding).should eq msg
  end
end
