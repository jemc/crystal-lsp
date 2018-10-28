# TODO: avoid re-opening Nil here
struct Nil
  def self.new
    nil
  end
end
