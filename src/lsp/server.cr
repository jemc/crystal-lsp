require "uuid"

class LSP::Server
  def initialize(@in : IO, @out : IO)
    @started = false
    @incoming = Channel(Message::Any).new
    @outstanding = {} of (String | Int64) => Message::AnyRequest
  end
  
  def receive
    if !@started
      @started = true
      spawn do
        loop do
          msg = LSP::Codec.read_message(@in, @outstanding)
          if msg.is_a?(Message::Any)
            @incoming.send msg
          end
        end
      end
    end
    @incoming.receive
  end
  
  def notify(m_class : M.class): M forall M
    msg : M = yield M.new
    LSP::Codec.write_message(@out, msg, @outstanding)
    msg
  end
  
  def request(m_class : M.class): M forall M
    msg : M = yield M.new(UUID.random.to_s)
    LSP::Codec.write_message(@out, msg, @outstanding)
    msg
  end
  
  def respond(req : M): M::Response forall M
    msg : M::Response = yield req.new_response
    LSP::Codec.write_message(@out, msg, @outstanding)
    msg
  end
end
