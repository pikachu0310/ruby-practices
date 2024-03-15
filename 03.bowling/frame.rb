# frozen_string_literal: true

class Frame
  attr_reader :shots

  def initialize(shots, is_last_frame: false)
    @shots = shots
    @is_last_frame = is_last_frame
  end

  def pins
    @shots.map(&:pin)
  end

  def score(index, all_frames)
    pins.sum + calc_bonus(index, all_frames)
  end

  def strike?
    @shots.first.strike?
  end

  private

  def spare?
    !strike? && pins[0..1].sum == 10
  end

  def calc_bonus(index, all_frames)
    if strike?
      calc_strike_bonus(index, all_frames)
    elsif spare?
      calc_spare_bonus(index, all_frames)
    else
      0
    end
  end

  def calc_strike_bonus(index, all_frames)
    if @is_last_frame
      0
    else
      next_shots = all_frames[index + 1].shots + (all_frames[index + 2]&.shots || [])
      next_shots[0..1].sum(&:pin)
    end
  end

  def calc_spare_bonus(index, all_frames)
    @is_last_frame ? 0 : all_frames[index + 1].shots.first.pin
  end
end
