# frozen_string_literal: true

require_relative 'game'
require_relative 'frame'
require_relative 'shot'

def calc_score_and_print(shots)
  game = Game.new(shots)
  puts game.score
end

# Test case 1: All strikes
perfect_shots = 'X,X,X,X,X,X,X,X,X,X,X,X'
calc_score_and_print(perfect_shots) # => 300

# Test case 2: All spares
all_spares = '5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5'
calc_score_and_print(all_spares) # => 150

# Test case 3: All open frames
all_open_frames = '9,0,8,1,7,2,6,3,5,4,4,5,3,6,2,7,1,8,0,9'
calc_score_and_print(all_open_frames) # => 90

# Test case 4: All gutter balls
all_gutter_balls = '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0'
calc_score_and_print(all_gutter_balls) # => 0


