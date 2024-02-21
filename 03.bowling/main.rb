# frozen_string_literal: true

require_relative 'game'
require_relative 'frame'
require_relative 'shot'

game = Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
puts game.score # => 139

game = Game.new('X,X,X,X,X,X,X,X,X,X,X,X')
puts game.score # => 300
