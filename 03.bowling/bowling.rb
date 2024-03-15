#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'
require_relative 'frame'
require_relative 'shot'

def calc_score_and_print(shots)
  game = Game.new(shots)
  puts game.score
end

if ARGV.length != 1
  puts "Usage: #{$PROGRAM_NAME} 'score'"
  exit 1
end

shots = ARGV[0]
calc_score_and_print(shots)
