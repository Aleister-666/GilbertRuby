
require 'chingu'
require 'gosu'
include Gosu
include Chingu

require_all 'game_objects/*'
require_all 'game_state/*'

class Game < Chingu::Window
  def initialize
    super(900, 600, false)
    self.caption = "Gilbert Ruby"
    self.input = {escape: :exit}
    push_game_state(Intro)
  end
end

Game.new.show