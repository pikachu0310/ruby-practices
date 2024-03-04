# frozen_string_literal: true

require_relative 'game'
require_relative 'frame'
require_relative 'shot'
require 'test/unit'

class TestBowling < Test::Unit::TestCase
  def test_perfect_game
    assert_equal(300, Game.new('X,X,X,X,X,X,X,X,X,X,X,X').score)
  end

  def test_all_spares
    assert_equal(150, Game.new('5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5').score)
  end

  def test_all_open_frames
    assert_equal(90, Game.new('9,0,8,1,7,2,6,3,5,4,4,5,3,6,2,7,1,8,0,9').score)
  end

  def test_all_gutter_balls
    assert_equal(0, Game.new('0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0').score)
  end

  def test_provided_test_cases
    assert_equal(139, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5').score)
    assert_equal(164, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X').score)
    assert_equal(107, Game.new('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4').score)
    assert_equal(134, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0').score)
    assert_equal(144, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8').score)
    assert_equal(300, Game.new('X,X,X,X,X,X,X,X,X,X,X,X').score)
    assert_equal(292, Game.new('X,X,X,X,X,X,X,X,X,X,X,2').score)
    assert_equal(50, Game.new('X,0,0,X,0,0,X,0,0,X,0,0,X,0,0').score)
  end
end
