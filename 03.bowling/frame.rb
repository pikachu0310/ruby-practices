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
    base_score = calc_base_score
    base_score + calculate_bonus(index, all_frames)
  end

  def strike?
    @shots.first.strike?
  end

  def spare?
    !strike? && pins[0..1].sum == 10
  end

  private

  def calc_base_score
    pins.sum
  end

  def calculate_bonus(index, all_frames)
    if strike?
      calculate_strike_bonus(index, all_frames)
    elsif spare?
      spare_bonus(index, all_frames)
    else
      0
    end
  end

  def calculate_strike_bonus(index, all_frames)
    if @is_last_frame
      0
    else
      next_shots = all_frames[index + 1].shots + (all_frames[index + 2]&.shots || [])
      next_shots[0..1].sum(&:pin)
    end
  end

  def spare_bonus(index, all_frames)
    return 0 if @is_last_frame

    all_frames[index + 1]&.shots&.first&.pin || 0
  end
end
