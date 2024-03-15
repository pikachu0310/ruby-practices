# frozen_string_literal: true

class Game
  def initialize(scores)
    @frames = build_frames(scores)
  end

  def score
    @frames.each_with_index.sum { |frame, index| frame.score(index, @frames) }
  end

  private

  def build_frames(scores)
    shots = scores.split(',').map { |s| Shot.new(s) }
    frames = Array.new(9) do
      if shots.first.strike?
        Frame.new([shots.shift])
      else
        Frame.new(shots.shift(2))
      end
    end
    # 最後のフレームは残りのすべてのshotsを使用
    [*frames, Frame.new(shots, is_last_frame: true)]
  end
end
