# frozen_string_literal: true

class Shot
  attr_reader :pin

  def initialize(mark)
    @pin = mark == 'X' ? 10 : mark.to_i
  end

  def strike?
    @pin == 10
  end
end
