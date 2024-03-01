# frozen_string_literal: true

class Frame
  attr_reader :shots

  def initialize(shots, is_last_frame: false)
    @shots = shots
    @is_last_frame = is_last_frame
  end

  def pins
    @shots.map(&:pins)
  end

  def score(index, all_frames)
    base_score = @is_last_frame ? calc_base_score_for_last : calc_base_score
    bonus = calculate_bonus(index, all_frames)
    base_score + bonus
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

  def calc_base_score_for_last
    base_score = pins.sum
    if @is_last_frame && strike?
      base_score -= pins[1..].sum
    elsif @is_last_frame && (@shots.size > 2)
      base_score -= pins[2..].sum
    end
    base_score
  end

  def calculate_bonus(index, all_frames)
    if strike?
      strike_bonus(index, all_frames)
    elsif spare?
      spare_bonus(index, all_frames)
    else
      0
    end
  end

  def strike_bonus(index, all_frames)
    return last_frame_strike_bonus if @is_last_frame

    normal_frame_strike_bonus(index, all_frames)
  end

  def last_frame_strike_bonus
    pins[1..2].sum
  end

  def normal_frame_strike_bonus(index, all_frames)
    next_shots = (all_frames[index + 1]&.shots || []) + (all_frames[index + 2]&.shots || [])
    next_shots[0..1].sum(&:pins)
  end

  def spare_bonus(index, all_frames)
    return last_frame_spare_bonus if @is_last_frame

    normal_frame_spare_bonus(index, all_frames)
  end

  def last_frame_spare_bonus
    @shots[2]&.pins || 0
  end

  def normal_frame_spare_bonus(index, all_frames)
    all_frames[index + 1]&.shots&.first&.pins || 0
  end
end
