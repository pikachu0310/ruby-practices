# frozen_string_literal: true

class Game
  def initialize(scores)
    @frames = build_frames(scores)
  end

  def score
    total_score = 0
    @frames.each_with_index do |frame, index|
      total_score += frame.score(index, @frames)
    end
    total_score
  end

  private

  def build_frames(scores)
    shots = scores.split(',').map { |s| Shot.new(s) }
    frames = []
    9.times do
      frames << if shots.first.strike?
                  Frame.new([shots.shift])
                else
                  Frame.new(shots.shift(2))
                end
    end
    # 最後のフレームは残りのすべてのshotsを使用
    frames << Frame.new(shots, is_last_frame: true)
    frames
  end
end
